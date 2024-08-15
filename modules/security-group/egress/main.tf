resource "aws_security_group" "main" {
  name   = var.name
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "ipv4" {
  count = length(var.cidr_ipv4)

  cidr_ipv4         = var.cidr_ipv4[count.index]
  ip_protocol       = (-1)
  security_group_id = aws_security_group.main.id
}

resource "aws_vpc_security_group_egress_rule" "ipv6" {
  count = length(var.cidr_ipv6)

  cidr_ipv6         = var.cidr_ipv6[count.index]
  ip_protocol       = (-1)
  security_group_id = aws_security_group.main.id
}

resource "aws_vpc_security_group_egress_rule" "prefix_list" {
  count = length(var.prefix_list_ids)

  ip_protocol       = (-1)
  prefix_list_id    = var.prefix_list_ids[count.index]
  security_group_id = aws_security_group.main.id
}
