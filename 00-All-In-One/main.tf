provider "aws" {
    region  = local.region 
}

module "modules" {
  source = "./modules"
}