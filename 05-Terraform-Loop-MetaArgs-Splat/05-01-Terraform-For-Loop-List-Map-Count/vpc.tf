resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  # public ip 할당을 위한 dns hostname 설정 flag
  enable_dns_hostnames = true

  tags = {
    Name = "test-hmkim-terraform-vpc"
    "hmkim" = "terraform-vpc"
  }
}

resource "aws_subnet" "example" {
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"
  # 해당 서브넷의 인스턴스에 퍼블릭 ip 부여
  map_public_ip_on_launch = true

  tags = {
    Name = "test-hmkim-terraform-pub-subnet"
    "hmkim" = "terraform-subnet"
  }
}