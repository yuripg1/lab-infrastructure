variable "name" {
  type = string
}

variable "ami" {
  type = string
}

variable "availability_zone" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "encrypted" {
  type = bool
}

variable "volume_size" {
  type = number
}

variable "volume_type" {
  type = string
}
