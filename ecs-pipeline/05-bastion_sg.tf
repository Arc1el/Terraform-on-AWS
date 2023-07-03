resource "aws_security_group_rule" "sg_rule_bastion1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.sg_bastion.id
  
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "sg_rule_bastion2" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_bastion.id
  
  lifecycle { create_before_destroy = true }
}


resource "aws_security_group" "sg_bastion" {
  vpc_id = module.vpc.vpc_id                                   #(필수) VPC 지정
  name = "${local.name}-prod-bastion"                           #(선택) Security Group 이름
  description = "bastion security group"                      #(선택) Description 내용
  egress {                                                  #(필수) Security Group에 egress를  모두 허용해야 합니다.
      from_port = 0                                         #(필수) 시작 포트
      to_port = 0                                           #(필수) 끝 포트
      protocol = "-1"                                       #(필수) 프로토콜 지정, -1은 ALL을 뜻함
      cidr_blocks = ["0.0.0.0/0"]                           #(선택) CIDR 블록
      ipv6_cidr_blocks = ["::/0"]                           #(선택) CIDR 블록
  }

  lifecycle {
    create_before_destroy = true                            # 기본적으로 Terraform이 원격 API 제한으로 인해 제자리에서 업데이트할 수 없는 리소스 인수를 변경해야 하는 경우 기존 객체를 파괴한 다음 새로 구성된 인수로 새 대체 객체를 생성합니다.
  }


  tags = {
    Name = "sg-${local.name}-bastion"
    Env  = local.env_name             
  }
}
