resource "aws_vpc" "main" {
  cidr_block                           = var.cidr_block
  instance_tenancy                     = "default"
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group
  enable_dns_support                   = true
  enable_dns_hostnames                 = true
  assign_generated_ipv6_cidr_block     = true

  tags = {
    "Name" = var.name
  }
}
