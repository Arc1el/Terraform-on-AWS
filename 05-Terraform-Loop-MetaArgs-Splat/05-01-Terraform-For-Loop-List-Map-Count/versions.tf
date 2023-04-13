terraform {
  # 20230413 기준 lts 1.4.4
  required_version = ">= 1.4.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"2
      # 20230413 기준 lts 4.0
      version = "~> 4.0"
    }
  }
}

# Provider 블록. AWS를 사용합니다.
provider "aws" {
  region  = var.aws_region
}