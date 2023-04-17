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

    # 고정아이피 쓸 갯수 (최대 : 3, 증설가능)
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

    #############################################################################
    ##                              EC2 설정                                   ##
    #############################################################################
    #생성할 EC2 instance이름, 타입, 키페어이름, 서브넷 아이디
    ec2_names = [["test_ec2", "t3.micro", "mykey", "mysg-1"]]


    #############################################################################
    ##                  Security Groups 설정                                   ##
    #############################################################################
    security_groups = {
        web-server = {
            name                  = "test-hmkim-terraform-web-server"
            description           = "Security group for web servers"
            ingress_with_cidr_blocks = [
                {
                from_port   = 8080
                to_port     = 8090
                protocol    = "tcp"
                description = "User-service ports"
                cidr_blocks = "10.10.0.0/16"
                },
                {
                rule        = "postgresql-tcp"
                cidr_blocks = "0.0.0.0/0"
                }
            ]
        },
        db-server = {
            name                  = "test-hmkim-terraform-db-server"
            description           = "Security group for database servers"
            ingress_with_cidr_blocks = [
                {
                from_port   = 5432
                to_port     = 5432
                protocol    = "tcp"
                description = "PostgreSQL"
                cidr_blocks = "10.10.0.0/16"
                }
            ]
        }
        my-test-rule = {
            name                  = "my-test-rule-name"
            description           = "test-rule-description"
            ingress_with_cidr_blocks = [
                {
                from_port   = 3000
                to_port     = 3000
                protocol    = "tcp"
                description = "express"
                cidr_blocks = "10.20.0.0/16"
                },
                {
                from_port   = 3001
                to_port     = 3001
                protocol    = "tcp"
                description = "express"
                cidr_blocks = "10.20.0.0/16"
                },
                {
                from_port   = 3002
                to_port     = 3002
                protocol    = "tcp"
                description = "express"
                cidr_blocks = "10.20.0.0/16"
                }
            ]
        }
    }
}
 ###########
 # vpc 설정
 ###########


module "security_group" {
    source = "terraform-aws-modules/security-group/aws"

    for_each = local.security_groups

    name        = each.key
    description = each.value.description

    vpc_id = module.vpc.vpc_id
    ingress_with_cidr_blocks = each.value.ingress_with_cidr_blocks

}

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

# module "ec2_instance" {
#   source  = "terraform-aws-modules/ec2-instance/aws"
#   version = "~> 3.0"

#   for_each = toset(["one", "two", "three"])

#   name = "instance-${each.key}"

#   ami                    = data.aws_ami.amzlinux2.id
#   instance_type          = "t2.micro"
#   key_name               = "user1"
#   monitoring             = true
#   vpc_security_group_ids = ["sg-12345678"]
#   subnet_id              = "subnet-eddcdzz4"

#   tags = {
#     Terraform   = "true"
#     Environment = "dev"
#   }
# }