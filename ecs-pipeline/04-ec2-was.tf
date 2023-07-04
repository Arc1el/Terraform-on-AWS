data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
 }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2_1" {
  ami                = "${local.ec2_instance_ami}"
  instance_type      = "${local.ec2_instance_type}"
  subnet_id          = "${local.ec2_instance_subnet}"
#  cpu_core_count = 2                                                      # Optimize CPU
#  cpu_threads_per_core = 2
  credit_specification {
    cpu_credits      = "unlimited"                                         # t2 타입 기본 standard,t3 타입 기본 unlimited
  }

  disable_api_termination = false                                          # 인스턴스 종료 보호 설정 (기본값은 false)

  root_block_device {
    volume_type      = "gp3"
    volume_size      = 100
  }
  # ebs_block_device {
  #   device_name      = "/dev/sdf"
  #   volume_size      = 100
  #   volume_type      = "gp3"
  #   delete_on_termination = false
  # } 
#  iam_instance_profile = aws_iam_instance_profile.ec2_role.name             # IAM Role 적용
  
  instance_initiated_shutdown_behavior = "stop"                                # OS Level의 종료 시, 인스턴스의 동작을 지정합니다.(기본값 STOP) terminate로 설정 가능
  key_name                  = aws_key_pair.key_1.key_name                        # 인스턴스에 사용할 Key Pair를 지정합니다.
  monitoring                = false                                          # 세부 모니터링 여부(기본값 false)
  vpc_security_group_ids    =  [aws_security_group.sg_pri.id]

  tags = {
    Name = "ec2-${local.name}-was"
    Env  = local.env_name
  }
}