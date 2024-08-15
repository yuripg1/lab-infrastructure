resource "aws_security_group" "main" {
  name   = var.name
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ipv4" {
  count = length(var.cidr_ipv4)

  cidr_ipv4         = var.cidr_ipv4[count.index]
  from_port         = var.from_port
  ip_protocol       = var.ip_protocol
  security_group_id = aws_security_group.main.id
  to_port           = var.to_port
}

resource "aws_vpc_security_group_ingress_rule" "ipv6" {
  count = length(var.cidr_ipv6)

  cidr_ipv6         = var.cidr_ipv6[count.index]
  from_port         = var.from_port
  ip_protocol       = var.ip_protocol
  security_group_id = aws_security_group.main.id
  to_port           = var.to_port
}

resource "aws_vpc_security_group_ingress_rule" "prefix_list" {
  count = length(var.prefix_list_ids)

  from_port         = var.from_port
  ip_protocol       = var.ip_protocol
  prefix_list_id    = var.prefix_list_ids[count.index]
  security_group_id = aws_security_group.main.id
  to_port           = var.to_port
}
