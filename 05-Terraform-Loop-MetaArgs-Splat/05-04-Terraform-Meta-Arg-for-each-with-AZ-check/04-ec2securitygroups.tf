# Create Security Group - SSH Traffic
resource "aws_security_group" "vpc-ssh" {
  vpc_id = aws_vpc.default.id
  name        = "test-hmkim-sg-ssh"
  description = "Security Group for SSH"
  # 인바운드
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # 아웃바운드
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "hmkim" = "test-hmkim-terraform-sg-ssh"
  }
}

# Create Security Group - Web Traffic
resource "aws_security_group" "vpc-web" {
  vpc_id = aws_vpc.default.id
  name        = "test-hmkim-sg-http-https"
  description = "Security Group for Webserver(http/https)"
  # 인바운드 :80
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # 인바운드 : 443
  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # 아웃바운드
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "hmkim" = "test-hmkim-terraform-sg-web"
  }
}