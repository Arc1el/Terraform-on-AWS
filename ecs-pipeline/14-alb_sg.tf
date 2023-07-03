resource "aws_security_group" "sg_alb" {
  name        = "${local.name}-prod-alb"
  description = "load balancer security group"
  vpc_id      = module.vpc.vpc_id 

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-${local.name}-prod-alb"
    Env  = local.env_name
  }
}