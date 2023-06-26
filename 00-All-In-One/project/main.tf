locals {
  environment = "dev"
  env_specific_vars = terraform.workspace == "dev" ? "./environments/dev/main.tfvars" : "./environments/prod/main.tfvars"
}

terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}