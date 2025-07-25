#################### Base ####################

project_name = "yuri"

environment = "prd"

aws_region = "sa-east-1"

number_of_availability_zones_to_use = 1

admin_key_pair_public_key = "ssh-ed25519 ***** *****"

ingress_ssh_ipv4_managed_prefix_list_entries_cidr = ["*.*.*.*/32"]

#################### iperf ####################

ingress_iperf_ipv4_managed_prefix_list_entries_cidr = ["*.*.*.*/32"]
ingress_iperf_ipv6_managed_prefix_list_entries_cidr = ["*:*:*:*::/64"]

iperf_instance_ami         = "ami-0a174b8e659123575"
iperf_instance_type        = "t3.small"
iperf_instance_encryped    = true
iperf_instance_volume_size = 16
iperf_instance_volume_type = "gp3"
