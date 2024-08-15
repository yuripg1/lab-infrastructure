output "id" {
  value = aws_subnet.main.id
}

output "availability_zone" {
  value = aws_subnet.main.availability_zone
}

output "cidr_block" {
  value = aws_subnet.main.cidr_block
}

output "ipv6_cidr_block" {
  value = aws_subnet.main.ipv6_cidr_block
}
