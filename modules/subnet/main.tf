resource "aws_subnet" "main" {
  assign_ipv6_address_on_creation                = true
  availability_zone                              = var.availability_zone
  cidr_block                                     = var.cidr_block
  enable_resource_name_dns_aaaa_record_on_launch = true
  enable_resource_name_dns_a_record_on_launch    = true
  ipv6_cidr_block                                = var.ipv6_cidr_block
  map_public_ip_on_launch                        = var.map_public_ip_on_launch
  private_dns_hostname_type_on_launch            = "resource-name"
  vpc_id                                         = var.vpc_id

  tags = {
    Name = var.name
  }
}
