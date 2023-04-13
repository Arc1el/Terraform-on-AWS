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
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.public_rtb.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "test-hmkim-terraform-igw"
    "hmkim" = "terraform-igw"
  }
}