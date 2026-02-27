# Lab infrastructure

## Summary

This project aims to facilitate and quicken the creation of a secure cloud environment with one or more VMs for any necessary purposes (it's got "lab" in the name, after all).

It enables the creation and seamless integration of:

* VPC
* Subnet
* Internet Gateway
* Route Table
* Key Pair
* Prefix List
* Security Group
* EC2 Instance

You can configure its **[variables.tfvars](./environments/prd/variables.tfvars)** file to choose:

* Which AWS region to use
* How many availability zones to use
* Which key you want to centralize the management access to VMs via SSH
* From which addresses to allow management access via SSH

The current setup:

* Supports IPv4 and IPv6 connectivity
* Includes Security Groups that allow all egress traffic and ingress pings by default
* Allows management access via SSH by the specified addresses
* Spins up an Ubuntu 24.04 (amd64) VM with firewall rules aimed at allowing ingress traffic to an application such as iperf

## Basic prerequisites

Before running Terraform, it is necessary to have

* Appropriate IAM privileges and credentials
* S3 Bucket for storing **terraform.tfstate**
* Reference the S3 Bucket in the **[backend.config](./environments/prd/backend.config)** file

## Initialization and validations

```shell
$ cd ./src
$ terraform init -backend-config=../environments/prd/backend.config
$ terraform fmt -recursive .. && terraform validate
```

## First-time run

* Generate a private key for SSH access

```shell
$ ssh-keygen -t ed25519 -C "key-name"
```

* Paste the public key in the `admin_key_pair_public_key` variable
* Execute runs targeting `random_shuffle.used_availability_zones`, `random_integer.iperf_port` and `random_integer.iperf_subnet_index`:

```shell
$ terraform apply -target="random_shuffle.used_availability_zones" -var-file=../environments/prd/variables.tfvars
$ terraform apply -target="random_integer.iperf_port" -var-file=../environments/prd/variables.tfvars
$ terraform apply -target="random_integer.iperf_subnet_index" -var-file=../environments/prd/variables.tfvars
```

* Execute an all-encompassing run:

```shell
$ terraform apply -var-file=../environments/prd/variables.tfvars
```

## Regular runs

```shell
$ terraform apply -var-file=../environments/prd/variables.tfvars
```
