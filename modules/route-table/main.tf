resource "aws_route_table" "main" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.vpc_cidr_block
    gateway_id = "local"
  }

  route {
    ipv6_cidr_block = var.vpc_ipv6_cidr_block
    gateway_id      = "local"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = var.internet_gateway_id
  }

  tags = {
    Name = var.name
  }
}

resource "aws_route_table_association" "main" {
  count = length(var.subnet_ids)

  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.main.id
}
