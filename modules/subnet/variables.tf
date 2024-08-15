variable "name" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "ipv6_cidr_block" {
  type = string
}

variable "map_public_ip_on_launch" {
  type = bool
}

variable "vpc_id" {
  type = string
}
