resource "aws_security_group" "main" {
  name   = var.name
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "ipv4" {
  for_each = {
    for item in flatten([
      for egress_rule_index, egress_rule_entry in var.egress_rules : [
        for cidr_ipv4_index, cidr_ipv4_entry in egress_rule_entry.cidr_ipv4 : {
          index     = "${egress_rule_index}-${cidr_ipv4_index}"
          cidr_ipv4 = cidr_ipv4_entry
        }
      ]
    ]) : item.index => item
  }

  cidr_ipv4         = each.value.cidr_ipv4
  ip_protocol       = (-1)
  security_group_id = aws_security_group.main.id
}

resource "aws_vpc_security_group_egress_rule" "ipv6" {
  for_each = {
    for item in flatten([
      for egress_rule_index, egress_rule_entry in var.egress_rules : [
        for cidr_ipv6_index, cidr_ipv6_entry in egress_rule_entry.cidr_ipv6 : {
          index     = "${egress_rule_index}-${cidr_ipv6_index}"
          cidr_ipv6 = cidr_ipv6_entry
        }
      ]
    ]) : item.index => item
  }

  cidr_ipv6         = each.value.cidr_ipv6
  ip_protocol       = (-1)
  security_group_id = aws_security_group.main.id
}

resource "aws_vpc_security_group_egress_rule" "prefix_list" {
  for_each = {
    for item in flatten([
      for egress_rule_index, egress_rule_entry in var.egress_rules : [
        for prefix_list_id_index, prefix_list_id_entry in egress_rule_entry.prefix_list_ids : {
          index          = "${egress_rule_index}-${prefix_list_id_index}"
          prefix_list_id = prefix_list_id_entry
        }
      ]
    ]) : item.index => item
  }

  ip_protocol       = (-1)
  prefix_list_id    = each.value.prefix_list_id
  security_group_id = aws_security_group.main.id
}

resource "aws_vpc_security_group_ingress_rule" "ipv4" {
  for_each = {
    for item in flatten([
      for ingress_rule_index, ingress_rule_entry in var.ingress_rules : [
        for cidr_ipv4_index, cidr_ipv4_entry in ingress_rule_entry.cidr_ipv4 : {
          index       = "${ingress_rule_index}-${cidr_ipv4_index}"
          cidr_ipv4   = cidr_ipv4_entry
          from_port   = ingress_rule_entry.from_port
          ip_protocol = ingress_rule_entry.ip_protocol
          to_port     = ingress_rule_entry.to_port
        }
      ]
    ]) : item.index => item
  }

  cidr_ipv4         = each.value.cidr_ipv4
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  security_group_id = aws_security_group.main.id
  to_port           = each.value.to_port
}

resource "aws_vpc_security_group_ingress_rule" "ipv6" {
  for_each = {
    for item in flatten([
      for ingress_rule_index, ingress_rule_entry in var.ingress_rules : [
        for cidr_ipv6_index, cidr_ipv6_entry in ingress_rule_entry.cidr_ipv6 : {
          index       = "${ingress_rule_index}-${cidr_ipv6_index}"
          cidr_ipv6   = cidr_ipv6_entry
          from_port   = ingress_rule_entry.from_port
          ip_protocol = ingress_rule_entry.ip_protocol
          to_port     = ingress_rule_entry.to_port
        }
      ]
    ]) : item.index => item
  }

  cidr_ipv6         = each.value.cidr_ipv6
  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  security_group_id = aws_security_group.main.id
  to_port           = each.value.to_port
}

resource "aws_vpc_security_group_ingress_rule" "prefix_list" {
  for_each = {
    for item in flatten([
      for ingress_rule_index, ingress_rule_entry in var.ingress_rules : [
        for prefix_list_id_index, prefix_list_id_entry in ingress_rule_entry.prefix_list_ids : {
          index          = "${ingress_rule_index}-${prefix_list_id_index}"
          prefix_list_id = prefix_list_id_entry
          from_port      = ingress_rule_entry.from_port
          ip_protocol    = ingress_rule_entry.ip_protocol
          to_port        = ingress_rule_entry.to_port
        }
      ]
    ]) : item.index => item
  }

  from_port         = each.value.from_port
  ip_protocol       = each.value.ip_protocol
  prefix_list_id    = each.value.prefix_list_id
  security_group_id = aws_security_group.main.id
  to_port           = each.value.to_port
}
