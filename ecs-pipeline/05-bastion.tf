locals {
  bastion_instance_ami = "ami-0c9c942bd7bf113a2" # Ubuntu, 22.04 LTS, amd64
  bastion_instance_type = "t3.micro"
  bastion_instance_subnet = module.vpc.subnet_id["01.sub-${local.name}-prod-pub-a-01"]
}
module "ec2_instance"{
  source                                = "terraform-aws-modules/ec2-instance/aws"
  instance_initiated_shutdown_behavior  = "stop"
  disable_api_termination               = false
  monitoring                            = false
  instance_type                         = "${local.bastion_instance_type}"
  ami                                   = local.bastion_instance_ami
  key_name                              = aws_key_pair.key_1.key_name
  vpc_security_group_ids                = [aws_security_group.sg_bastion.id]
  subnet_id                             = "${local.bastion_instance_subnet}"

  root_block_device = [{
    volume_type = "gp3"
    volume_size = 30
  }]

  tags = {
    Name = "ec2-${local.name}-bastion"
    Env  = local.env_name
  }
  
}
resource "aws_eip" "eip_bastion" {
  vpc      = true
  instance = module.ec2_instance.id
}