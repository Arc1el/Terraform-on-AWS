

resource "aws_security_group_rule" "sg_rule_pri1" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = -1
  self              = true
  security_group_id = aws_security_group.sg_pri.id
  
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "sg_rule_pri3" {
  type                      = "ingress"
  from_port                 = 0
  to_port                   = 65535
  protocol                  = -1
  source_security_group_id  = aws_security_group.sg_bastion.id
  security_group_id         = aws_security_group.sg_pri.id
  
  lifecycle { create_before_destroy = true }
}

resource "aws_security_group_rule" "sg_rule_pri4" {
  type                      = "ingress"
  from_port                 = 0
  to_port                   = 65535
  protocol                  = -1
  source_security_group_id  = aws_security_group.sg_alb.id
  security_group_id         = aws_security_group.sg_pri.id
  
  lifecycle { create_before_destroy = true }
}