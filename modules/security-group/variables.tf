variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "egress_rules" {
  type = list(object({
    cidr_ipv4       = optional(list(string), [])
    cidr_ipv6       = optional(list(string), [])
    prefix_list_ids = optional(list(string), [])
  }))
  default = []
}

variable "ingress_rules" {
  type = list(object({
    cidr_ipv4       = optional(list(string), [])
    cidr_ipv6       = optional(list(string), [])
    from_port       = number
    ip_protocol     = string
    prefix_list_ids = optional(list(string), [])
    to_port         = number
  }))
  default = []
}
