terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "ap-northeast-2"
}
provider "aws" {
  alias   = "virginia"
  region  = "us-east-1"
}
locals {
  region = "ap-northeast-2"
  role_arn = "arn:aws:iam::759320821027:role/ducku-haha"
  name   = "hmkim" # project name
  key_name = "hmkim-key"
  env_name = "prod"

  ec2_instance_ami = "ami-04cebc8d6c4f297a3"
  ec2_instance_type = "t3.small"
  ec2_instance_subnet = module.vpc.subnet_id["03.sub-${local.name}-prod-pri-a-01"]

  bastion_instance_ami = "ami-0c9c942bd7bf113a2"
  bastion_instance_type = "t3.micro"
  bastion_instance_subnet = module.vpc.subnet_id["01.sub-${local.name}-prod-pub-a-01"]

  rds_identifier = "db-hmkim-prod"
  rds_instance_class = "db.t3.small"
  rds_db_subent = [module.vpc.subnet_id["05.sub-${local.name}-prod-db-a-01"],
                  module.vpc.subnet_id["06.sub-${local.name}-prod-db-c-01"]]
  rds_user = "admin"
  rds_password = "peteasyadmin12!!"

  bucket_name = "hmkim-cf-bucket"

  create_route53_zone = false
  route53_zone_id = "Z07944031UQG8BIM8ILPY"
  //create_route53_zone = true
  //route53_zone_id = element(aws_route53_zone.main.*.zone_id, 0) 
  domain_name = "hyeon.cloud"
  cdn_domain_name = "cdn.hyeon.cloud"

  alb_subnet = [module.vpc.subnet_id["03.sub-${local.name}-prod-pri-a-01"],
                module.vpc.subnet_id["04.sub-${local.name}-prod-pri-c-01"]]

  codepipeline_bucket_name = "hmkim-codepipeline-bucket"
}