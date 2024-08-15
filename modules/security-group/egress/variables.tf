variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "cidr_ipv4" {
  type = list(string)
}

variable "cidr_ipv6" {
  type = list(string)
}

variable "prefix_list_ids" {
  type = list(string)
}
