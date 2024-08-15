variable "name" {
  type = string
}

variable "address_family" {
  type = string
}

variable "max_entries" {
  type = number
}

variable "entries_cidr" {
  type = list(string)
}
