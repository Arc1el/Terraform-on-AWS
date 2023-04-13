# Resource: EC2 Instance
resource "aws_instance" "test-hmkim-terraform-ec2" {
  ami = "ami-09cd5dd529c3c1f40"
  instance_type = "t3.micro"
  user_data = file("${path.module}/app1-install.sh")
  subnet_id = aws_subnet.example.id
  vpc_security_group_ids = ["${aws_security_group.webserver-sg.id}"]
  tags = {  
    "Name" = "test-hmkim-terraform-ec2"
    "hmkim" = "EC2"
  }
}