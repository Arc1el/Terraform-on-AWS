resource "aws_instance" "myec2vm" {
  # 최신 AMI 이미지를 사용합니다
  ami = data.aws_ami.amzlinux2.id
  # 지정된 인스턴스 타입을 설정합니다 (리스트)
  # instance_type = var.instance_type_list[1]
  # 지정된 인스턴스 타입을 설정합니다 (맵)
  instance_type = var.instance_type
  # 메타인수 Count 설정
  # count = 1
  # 유저데이터를 지정합니다. 간단한 웹서버 띄우기
  user_data = file("${path.module}/00-app1-install.sh")
  # 사용될 키페어를 지정합니다.
  key_name = var.instance_keypair
  # 서브넷을 지정합니다.count          = length(aws_subnet.example)
  subnet_id      = aws_subnet.example.id
  # 시큐리티그룹을 리스트로 가져오기
  vpc_security_group_ids = [aws_security_group.vpc-ssh.id, aws_security_group.vpc-web.id]

  # for_each를 사용하여 모든가용영역에 인스턴스를 생성합니다.
  # for_each = toset(data.aws_availability_zones.my_azones.names)
  for_each = toset(keys({ for az, details in data.aws_ec2_instance_type_offerings.my_ins_type :
  az => details.instance_types if length(details.instance_types) != 0 }))

  availability_zone = each.key
  tags = {
    Name = "test-hmkim-terraform-ec2instance-for-each-${each.key}"
    "hmkim" = "test-hmkim-terraform-azs"
  }
}