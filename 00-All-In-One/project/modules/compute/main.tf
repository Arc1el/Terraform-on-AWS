resource "aws_instance" "example_instance" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = var.instance_type

  tags = {
    Name = "example-instance"
  }
}
