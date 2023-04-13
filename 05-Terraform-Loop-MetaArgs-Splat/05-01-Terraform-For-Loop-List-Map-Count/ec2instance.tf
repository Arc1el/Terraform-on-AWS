resource "aws_instance" "myec2vm" {
  # 최신 AMI 이미지를 사용합니다
  ami = data.aws_ami.amzlinux2.id
  # 지정된 인스턴스 타입을 설정합니다
  instance_type = var.instance_type
  # 유저데이터를 지정합니다. 간단한 웹서버 띄우기
  user_data = file("${path.module}/app1-install.sh")
  # 사용될 키페어를 지정합니다.
  key_name = var.instance_keypair
  # 서브넷을 지정합니다.
  subnet_id = aws_subnet.example.id
  # 시큐리티그룹을 리스트로 가져오기
  vpc_security_group_ids = [ aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id   ]
  # 태그를 설정합니다
  tags = {
    "Name" = "test-hmkim-terraform-ec2instance"
    "hmkim"= "terraform-instane"
  }
}