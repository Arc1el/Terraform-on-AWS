# Local변수 설정
locals {
    region                          = "ap-northeast-2"
    vpcname                         = var.vpcname
    vpc_cider                       = var.vpc_cider
    source                          = "terraform-aws-modules/vpc/aws"
    azs                             = slice(data.aws_availability_zones.available.names, 0, max(length(var.pub_subnets), length(var.pri_subnets), length(var.database_subnets)))
}

# 사용가능한 AZ 로드
data "aws_availability_zones" "available" {}

# 프로바이더 설정
provider "aws" {
    region  = local.region 
}

# VPC 설정
module "vpc" {
    source    = local.source
    cidr      = local.vpc_cider
    
    azs                             = local.azs
    public_subnets                  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
    private_subnets                 = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
    database_subnets                = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]

    public_subnet_names             = var.pub_subnets
    private_subnet_names            = var.pri_subnets
    database_subnet_names           = var.database_subnets

    create_database_subnet_group    = true
    manage_default_network_acl      = false
    manage_default_route_table      = false
    manage_default_security_group   = false

    enable_dns_hostnames            = true
    enable_dns_support              = true

    enable_nat_gateway              = true
    single_nat_gateway              = true

    customer_gateways = {
        IP1 = {
        bgp_asn     = 65112
        ip_address  = "1.2.3.4"
        device_name = "some_name"
        },
        IP2 = {
        bgp_asn    = 65112
        ip_address = "5.6.7.8"
        }
    }

    enable_vpn_gateway              = true
    tags                            = local.tags
}