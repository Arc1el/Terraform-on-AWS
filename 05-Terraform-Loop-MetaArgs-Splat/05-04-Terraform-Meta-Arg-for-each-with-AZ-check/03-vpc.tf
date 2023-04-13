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
  count             = length(var.azs)
  vpc_id            = aws_vpc.default.id
  cidr_block        = "10.0.${count.index + 1}.0/24"
  availability_zone = element(var.azs, count.index)
  # 해당 서브넷의 인스턴스에 퍼블릭 ip 부여
  map_public_ip_on_launch = true

  tags = {
    Name = "test-hmkim-terraform-pub-subnet"
    "hmkim" = "terraform-subnet"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "test-hmkim-public-rtb"
    "hmkim" = "pub routing table"
  }
}

resource "aws_route" "public_rtb" {
  route_table_id         = aws_route_table.public_rtb.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_rtb" {
  count          = length(var.azs)
  subnet_id      = aws_subnet.example[count.index].id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "test-hmkim-terraform-igw"
    "hmkim" = "terraform-igw"
  }
}