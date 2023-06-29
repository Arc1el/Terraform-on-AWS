# 로컬변수 설정
locals {
  env                 = "dev"
  vpc_name            = "01.vpc-hmkim-dev"
  public_vpc_name     = ["subnet-hmkim-dev-pub-a-01", "subnet-hmkim-dev-pub-c-01"]
  public_vpc_az       = ["ap-northeast-2a", "ap-northeast-2c"]
  private_vpc_name    = ["subnet-hmkim-dev-pri-a-01", "subnet-hmkim-dev-pri-a-02", "subnet-hmkim-dev-pri-c-01", "subnet-hmkim-dev-pri-c-02"]
  private_vpc_az      = ["ap-northeast-2a", "ap-northeast-2a", "ap-northeast-2c", "ap-northeast-2c"]
}
# VPC 설정
resource "aws_vpc" "vpc" {
  cidr_block            = "10.0.0.0/16"
  instance_tenancy      = "default"
  enable_dns_support    = true
  enable_dns_hostnames  = true
  tags = {
    Name = local.vpc_name
    Env = local.env
    CreatedDate = formatdate("YYYY-MM-DD HH:mm:ss", timestamp())
  }
}
# 퍼블릭 서브넷
resource "aws_subnet" "public_subnet" {
  count             = length(local.public_vpc_name)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.${count.index}.0/24"
  availability_zone = local.public_vpc_az[count.index]
  tags = {
    Name = local.public_vpc_name[count.index]
    Env = local.env
    CreatedDate = formatdate("YYYY-MM-DD HH:mm:ss", timestamp())
  }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "public-route-table"
    Env = local.env
    CreatedDate = formatdate("YYYY-MM-DD HH:mm:ss", timestamp())
  }
}
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(local.public_vpc_name)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}
# 프라이빗 서브넷
resource "aws_subnet" "private_subnet" {
  count             = length(local.private_vpc_name)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.10${count.index}.0/24"
  availability_zone = local.private_vpc_az[count.index]
  tags = {
    Name =  local.private_vpc_name[0]
    Env = local.env
    CreatedDate = formatdate("YYYY-MM-DD HH:mm:ss", timestamp())
  }
}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "private-route-table"
    Env = local.env
    CreatedDate = formatdate("YYYY-MM-DD HH:mm:ss", timestamp())
  }
}
resource "aws_route_table_association" "private_subnet_association" {
  count          = length(local.public_vpc_name)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}
# 인터넷 게이트웨이
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "my-igw"
    Env = local.env
    CreatedDate = formatdate("YYYY-MM-DD HH:mm:ss", timestamp())
  }
}
# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = {
    Name        = "nat-gateway"
    Env         = local.env
    CreatedDate = formatdate("YYYY-MM-DD HH:mm:ss", timestamp())
  }
}
# EIP (Elastic IP)
resource "aws_eip" "nat_eip" {
  vpc        = true
  tags = {
    Name        = "nat-eip"
    Env         = local.env
    CreatedDate = formatdate("YYYY-MM-DD HH:mm:ss", timestamp())
  }
}