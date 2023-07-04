module "vpc" {
  source = "./modules/vpc"
  vpc    = [{ 
    name = "01.vpc-${local.name}-prod" 
    cidr = "10.0.0.0/16" 

  }]


  subnet = [
    {name="01.sub-${local.name}-prod-pub-a-01", cidr = "10.0.1.0/24",default_gateway = "igw" },
    {name="02.sub-${local.name}-prod-pub-c-01", cidr = "10.0.2.0/24",default_gateway = "igw" },
    {name="03.sub-${local.name}-prod-pri-a-01", cidr = "10.0.11.0/24",default_gateway = "nat" },
    {name="04.sub-${local.name}-prod-pri-c-01", cidr = "10.0.22.0/24", default_gateway = "nat" },
    {name="05.sub-${local.name}-prod-db-a-01", cidr = "10.0.31.0/24", default_gateway = "non" },
    {name="06.sub-${local.name}-prod-db-c-01", cidr = "10.0.32.0/24", default_gateway = "non" },
  ]
  igw = true 
  nat = ["01.sub-${local.name}-prod-pub-a-01", "02.sub-${local.name}-prod-pub-c-01"]

  tags = { 
    Env  = local.env_name
  }
}