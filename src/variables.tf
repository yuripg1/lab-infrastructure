#################### Base ####################

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "number_of_availability_zones_to_use" {
  type = number
}

variable "admin_key_pair_public_key" {
  type = string
}

variable "ingress_ssh_ipv4_managed_prefix_list_entries_cidr" {
  type = list(string)
}

#################### iperf ####################

variable "ingress_iperf_ipv4_managed_prefix_list_entries_cidr" {
  type = list(string)
}

variable "ingress_iperf_ipv6_managed_prefix_list_entries_cidr" {
  type = list(string)
}

variable "iperf_instance_ami" {
  type = string
}

variable "iperf_instance_type" {
  type = string
}

variable "iperf_instance_encryped" {
  type = bool
}

variable "iperf_instance_volume_size" {
  type = number
}

variable "iperf_instance_volume_type" {
  type = string
}
