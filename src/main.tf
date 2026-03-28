#################### Base ####################

resource "random_integer" "vpc_cidr_block_part" {
  min = 0
  max = 255
}

resource "random_shuffle" "used_availability_zones" {
  input        = data.aws_availability_zones.available.names
  result_count = var.number_of_availability_zones_to_use
}

# VPC
module "vpc" {
  source = "../modules/vpc"

  name                                 = "vpc-${var.project_name}-${var.environment}"
  cidr_block                           = format("10.%d.0.0/16", random_integer.vpc_cidr_block_part.result)
  ipv6_cidr_block_network_border_group = var.aws_region
}

# Subnets (one for each Availability Zone)
module "subnets" {
  source = "../modules/subnet"

  count = length(random_shuffle.used_availability_zones.result)

  name                    = "subnet-${var.project_name}-${var.environment}-${random_shuffle.used_availability_zones.result[count.index]}"
  availability_zone       = random_shuffle.used_availability_zones.result[count.index]
  cidr_block              = cidrsubnet(module.vpc.cidr_block, 6, count.index)
  ipv6_cidr_block         = cidrsubnet(module.vpc.ipv6_cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  vpc_id                  = module.vpc.id
}

# Internet Gateway (for IPv4/IPv6 ingress/egress in the Route Table)
module "internet_gateway" {
  source = "../modules/internet-gateway"

  name   = "igw-${var.project_name}-${var.environment}"
  vpc_id = module.vpc.id
}

# Route Table
module "route_table" {
  source = "../modules/route-table"

  name                = "rtb-${var.project_name}-${var.environment}"
  vpc_id              = module.vpc.id
  vpc_cidr_block      = module.vpc.cidr_block
  vpc_ipv6_cidr_block = module.vpc.ipv6_cidr_block
  internet_gateway_id = module.internet_gateway.id
  subnet_ids          = module.subnets[*].id
}

# Admin Key Pair
module "admin_key_pair" {
  source = "../modules/key-pair"

  name       = "${var.project_name}-${var.environment}-admin"
  public_key = var.admin_key_pair_public_key
}

# Ingress SSH IPv4 Managed Prefix List
module "ingress_ssh_ipv4_managed_prefix_list" {
  source = "../modules/managed-prefix-list"

  name           = "ingress-ssh-ipv4"
  address_family = "IPv4"
  max_entries    = 2
  entries_cidr   = var.ingress_ssh_ipv4_managed_prefix_list_entries_cidr
}

# Ingress SSH IPv6 Managed Prefix List
module "ingress_ssh_ipv6_managed_prefix_list" {
  source = "../modules/managed-prefix-list"

  name           = "ingress-ssh-ipv6"
  address_family = "IPv6"
  max_entries    = 2
  entries_cidr   = var.ingress_ssh_ipv6_managed_prefix_list_entries_cidr
}

# Essentials - Egress to anywhere / Ping from anywhere (Security Group)
module "essentials_security_group" {
  source = "../modules/security-group"

  name   = "essentials"
  vpc_id = module.vpc.id

  egress_rules = [
    {
      cidr_ipv4       = ["0.0.0.0/0"]
      cidr_ipv6       = ["::/0"]
      prefix_list_ids = []
    },
  ]

  ingress_rules = [
    {
      cidr_ipv4   = ["0.0.0.0/0"]
      from_port   = 8
      ip_protocol = "icmp"
      to_port     = 0
    },
    {
      cidr_ipv6   = ["::/0"]
      from_port   = 128
      ip_protocol = "icmpv6"
      to_port     = 0
    },
  ]
}

# Ingress SSH (Security Group)
module "ingress_ssh_security_group" {
  source = "../modules/security-group"

  name   = "ingress-ssh"
  vpc_id = module.vpc.id

  ingress_rules = [
    {
      from_port   = 22
      ip_protocol = "tcp"
      to_port     = 22

      prefix_list_ids = [
        module.ingress_ssh_ipv4_managed_prefix_list.id,
        module.ingress_ssh_ipv6_managed_prefix_list.id,
      ],
    },
  ]
}

#################### iperf ####################

resource "random_integer" "iperf_port" {
  min = 49152
  max = 65535
}

resource "random_integer" "iperf_subnet_index" {
  min = 0
  max = length(module.subnets) - 1
}

# Ingress iperf IPv4 Managed Prefix List
module "ingress_iperf_ipv4_managed_prefix_list" {
  source = "../modules/managed-prefix-list"

  name           = "ingress-iperf-ipv4"
  address_family = "IPv4"
  max_entries    = 2
  entries_cidr   = var.ingress_iperf_ipv4_managed_prefix_list_entries_cidr
}

# Ingress iperf IPv6 Managed Prefix List
module "ingress_iperf_ipv6_managed_prefix_list" {
  source = "../modules/managed-prefix-list"

  name           = "ingress-iperf-ipv6"
  address_family = "IPv6"
  max_entries    = 2
  entries_cidr   = var.ingress_iperf_ipv6_managed_prefix_list_entries_cidr
}

# Ingress iperf (Security Group)
module "ingress_iperf_security_group" {
  source = "../modules/security-group"

  name   = "ingress-iperf"
  vpc_id = module.vpc.id

  ingress_rules = [
    {
      from_port   = random_integer.iperf_port.result
      ip_protocol = "tcp"
      to_port     = random_integer.iperf_port.result

      prefix_list_ids = [
        module.ingress_ssh_ipv4_managed_prefix_list.id,
        module.ingress_iperf_ipv6_managed_prefix_list.id,
      ]
    },
    {
      from_port   = random_integer.iperf_port.result
      ip_protocol = "udp"
      to_port     = random_integer.iperf_port.result

      prefix_list_ids = [
        module.ingress_ssh_ipv4_managed_prefix_list.id,
        module.ingress_iperf_ipv6_managed_prefix_list.id,
      ]
    },
  ]
}

# iperf EC2 Instance
module "iperf_ec2_instance" {
  source = "../modules/ec2-instance"

  name              = "iperf-${var.environment}"
  ami               = data.aws_ami.ubuntu_image.id
  availability_zone = module.subnets[random_integer.iperf_subnet_index.result].availability_zone
  instance_type     = var.iperf_instance_type
  key_name          = module.admin_key_pair.key_name
  subnet_id         = module.subnets[random_integer.iperf_subnet_index.result].id
  encrypted         = var.iperf_instance_encryped
  volume_size       = var.iperf_instance_volume_size
  volume_type       = var.iperf_instance_volume_type

  vpc_security_group_ids = [
    module.essentials_security_group.id,
    module.ingress_ssh_security_group.id,
    module.ingress_iperf_security_group.id,
  ]
}
