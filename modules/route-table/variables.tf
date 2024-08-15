variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "vpc_ipv6_cidr_block" {
  type = string
}

variable "internet_gateway_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}
