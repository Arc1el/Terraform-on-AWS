resource "aws_vpc" "example_vpc" {
  cidr_block = var.cidr_block

  tags = {
    Name = "example-vpc"
  }
}