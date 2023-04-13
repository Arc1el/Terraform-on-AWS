resource "aws_instance" "myec2vm" {
  # 최신 AMI 이미지 가져오기
  ami = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type
  user_data = file("${path.module}/app1-install.sh")
  key_name = var.instance_keypair
  subnet_id = aws_subnet.example.id
  # 시큐리티그룹을 리스트로 가져오기
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id   ]
  tags = {
    "Name" = "EC2 Demo 2"
  }
}