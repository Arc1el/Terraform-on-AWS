resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "test-hmkim-terraform-vpc"
    "hmkim" = "vpc"
  }
}

resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    "hmkim" = "terraform-subnet"
    Name = "test-hmkim-terraform-pub-subnet"
  }
}