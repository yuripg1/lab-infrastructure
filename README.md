# Project Base

## Initialization and validations

```
$ cd ./src
$ terraform init -backend-config=../environments/{environment}/backend.config
$ terraform fmt -recursive .. && terraform validate
```

## First-time run

* Generate a private key for SSH access

```
$ ssh-keygen -t ed25519 -C "key-name"
```

* Paste the public key in the `admin_key_pair_public_key` variable
* Execute runs targeting `random_shuffle.used_availability_zones`, `random_integer.iperf_port` and `random_integer.iperf_subnet_index`:

```
$ terraform apply -target="random_shuffle.used_availability_zones" -var-file=../environments/{environment}/variables.tfvars
$ terraform apply -target="random_integer.iperf_port" -var-file=../environments/{environment}/variables.tfvars
$ terraform apply -target="random_integer.iperf_subnet_index" -var-file=../environments/{environment}/variables.tfvars
```

* Execute an all-encompassing run:

```
$ terraform apply -var-file=../environments/{environment}/variables.tfvars
```

## Regular runs

```
$ terraform apply -var-file=../environments/{environment}/variables.tfvars
```
