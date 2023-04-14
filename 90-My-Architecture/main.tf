# Local변수 설정
locals {
    #############################################################################
    ##                              VPC 설정                                   ##
    #############################################################################
    # 리전 
    region      = "ap-northeast-2"

    # VPC
    vpc_name    = "hmkim-MYVPC"
    vpc_cidr    = "10.0.0.0/16"
    vpc_azs     = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
    
    # 서브넷 이름 (사이더는 자동으로 선택됨)
    pub_subnet_names = ["pub-subnet-0", "pub-subnet-1", "pub-subnet-2"]
    pri_subnet_names = ["pri-subnet-0", "pri-subnet-1", "pri-subnet-2"]
    db_subnet_names  = ["db-subnet-0", "db-subnet-1", "db-subnet-2", ]

    # 고정아이피 쓸 갯수 (최대 : 3)
    num_eips    = 3

    # NatGateway (시나리오)
    # One Nat Gateway per subnet            : 1-0-0
    # Single Nat Gateway                    : 1-1-0
    # One Nat Gateway per availability zone : 1-0-1
    nat_gateway_scenario = ["1", "1", "0"]
    # NatGateway 이름
    nat_gateway_name = "myNatGateway"

    # 데이터베이스
    # DB서브넷 그룹 생성
    db_subnet_group = "true"
    db_subnet_group_name = "Terraform-DB-subnet-group-hmkim"
    # DB라우팅 테이블 생성
    db_subnet_route_table = "true"
    # DB인터넷 게이트웨이 라우트 생성
    db_internet_gateway_route = "false"
    
    # DNS호스트네임
    dns_hostname = "true"
    dns_support = "true"

    # Redshift 클러스터 Public Access
    public_redshift = "false"

}





































data "aws_availability_zones" "available" {}

provider "aws" {
    region  = local.region 
}

module "vpc" {
    source    = "terraform-aws-modules/vpc/aws"
    cidr      = local.vpc_cidr
    default_vpc_tags = { Name = local.vpc_name}
    
    azs                             = local.vpc_azs
    public_subnets                  = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr, 8, k)]
    private_subnets                 = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
    database_subnets                = [for k, v in local.vpc_azs : cidrsubnet(local.vpc_cidr, 8, k + 8)]

    public_subnet_names             = local.pub_subnet_names
    private_subnet_names            = local.pri_subnet_names
    database_subnet_names           = local.db_subnet_names

    create_database_subnet_group           = local.db_subnet_group
    database_subnet_group_name             = local.db_subnet_group_name
    create_database_subnet_route_table     = local.db_subnet_route_table
    create_database_internet_gateway_route = local.db_internet_gateway_route

    enable_dns_hostnames = local.dns_hostname
    enable_dns_support   = local.dns_support

    enable_public_redshift = local.public_redshift

    manage_default_network_acl      = false
    manage_default_route_table      = false
    manage_default_security_group   = false

    enable_nat_gateway              = local.nat_gateway_scenario[0]
    single_nat_gateway              = local.nat_gateway_scenario[1]
    one_nat_gateway_per_az          = local.nat_gateway_scenario[2]
    nat_gateway_tags                = { Name = local.nat_gateway_name}

    tags = {
      "Terraform" = "true"
      "Environment" = "dev"
    }
}