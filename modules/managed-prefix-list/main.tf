resource "aws_ec2_managed_prefix_list" "main" {
  address_family = var.address_family
  max_entries    = var.max_entries
  name           = var.name
}

resource "aws_ec2_managed_prefix_list_entry" "main" {
  count = length(var.entries_cidr)

  cidr           = var.entries_cidr[count.index]
  prefix_list_id = aws_ec2_managed_prefix_list.main.id
}
