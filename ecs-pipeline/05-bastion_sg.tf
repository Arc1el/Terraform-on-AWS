resource "aws_security_group" "sg_bastion" {
  vpc_id = module.vpc.vpc_id  
  name = "${local.name}-prod-bastion"
  description = "bastion security group"
  egress { 
      from_port = 0
      to_port = 0 
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"] 
  }
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "sg-${local.name}-bastion"
    Env  = local.env_name             
  }
}
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