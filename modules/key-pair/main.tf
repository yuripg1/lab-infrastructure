resource "aws_key_pair" "main" {
  key_name   = var.name
  public_key = var.public_key
}
