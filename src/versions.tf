terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.34"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.8"
    }
  }
  required_version = ">= 1.7"
}
