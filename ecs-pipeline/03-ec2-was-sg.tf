resource "aws_security_group" "sg_pri" {
  vpc_id = module.vpc.vpc_id
  name = "${local.name}-prod-was"
  description = "private was security group"
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
    Name = "sg-${local.name}-prod-was"
    Env  = local.env_name
  }
}
