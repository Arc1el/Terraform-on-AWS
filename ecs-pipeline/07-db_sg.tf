resource "aws_security_group" "sg_db" {
  vpc_id = module.vpc.vpc_id
  name = "${local.name}-prod-db"
  description = "database security group"
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
    Name = "sg-${local.name}-db"
    Env  = local.env_name
  }
}

resource "aws_security_group_rule" "sg_rule_db1" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  self              = true
  security_group_id = aws_security_group.sg_db.id
  
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "sg_rule_db2" {
  type                      = "ingress"
  from_port                 = 0
  to_port                   = 65535
  protocol                  = -1
  source_security_group_id  = aws_security_group.sg_pri.id  
  security_group_id         = aws_security_group.sg_db.id
  
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "sg_rule_db4" {
  type                      = "ingress"
  from_port                 = 0
  to_port                   = 65535
  protocol                  = -1
  source_security_group_id  = aws_security_group.sg_bastion.id  
  security_group_id         = aws_security_group.sg_db.id
  
  lifecycle { create_before_destroy = true }
}