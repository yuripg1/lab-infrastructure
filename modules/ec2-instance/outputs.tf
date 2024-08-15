output "id" {
  value = aws_instance.main.id
}

output "private_ip" {
  value = aws_instance.main.private_ip
}

output "ipv6_addresses" {
  value = aws_instance.main.ipv6_addresses
}
