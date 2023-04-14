# Local변수 설정
locals {
    # 리전 설정
    region      = "ap-northeast-2"

    # VPC설정
    vpc_name    = "hmkim-MYVPC"
    vpc_cidr    = "10.0.0.0/16"
    vpc_azs     = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
    vpc_tags    = { "Name" = "Terrafom Test VPC"}
    
    # 서브넷 이름 설정 (사이더는 자동으로 선택됨)
    pub_subnet_names = ["pub-subnet-0", "pub-subnet-1", "pub-subnet-2"]
    pri_subnet_names = ["pri-subnet-0", "pri-subnet-1", "pri-subnet-2"]
    db_subnet_names  = ["db-subnet-0", "db-subnet-1", "db-subnet-2", ]

    # 고정아이피 쓸 갯수 (최대 : 3)
    num_eips    = 3

    # NatGateway 설정
    # One Nat Gateway per subnet            : true-false-false
    # Single Nat Gateway                    : true-true-false
    # One Nat Gateway per availability zone : ture-false-true
    nat_gateway_scenario = ["1", "0", "0"]
    


}

# 사용가능한 AZ 로드
data "aws_availability_zones" "available" {}

# 프로바이더 설정
provider "aws" {
    region  = local.region 
}

# VPC 설정
module "vpc" {
    source    = "terraform-aws-modules/vpc/aws"
    cidr      = local.vpc_cidr
    default_vpc_tags = local.vpc_tags
    
    azs                             = local.vpc_azs
    public_subnets                  = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr, 8, k)]
    private_subnets                 = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
    database_subnets                = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]

    public_subnet_names             = local.pub_subnet_names
    private_subnet_names            = local.pri_subnet_names
    database_subnet_names           = local.db_subnet_names

    create_database_subnet_group    = false
    manage_default_network_acl      = false
    manage_default_route_table      = false
    manage_default_security_group   = false

    enable_dns_hostnames            = true
    enable_dns_support              = true

    enable_nat_gateway              = local.nat_gateway_scenario[0]
    single_nat_gateway              = local.nat_gateway_scenario[1]
    one_nat_gateway_per_az          = local.nat_gateway_scenario[2]

    tags = {
      "Terraform" = "true"
      "Environment" = "dev"
    }
}