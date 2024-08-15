
resource "aws_instance" "main" {
  ami                     = var.ami
  availability_zone       = var.availability_zone
  disable_api_termination = true
  instance_type           = var.instance_type
  key_name                = var.key_name
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = var.vpc_security_group_ids

  root_block_device {
    delete_on_termination = true
    encrypted             = var.encrypted
    volume_size           = var.volume_size
    volume_type           = var.volume_type
  }

  tags = {
    Name = var.name
  }
}
