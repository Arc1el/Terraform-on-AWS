locals {
  alb_subent = [module.vpc.subnet_id["03.sub-${local.name}-prod-pri-a-01"], module.vpc.subnet_id["04.sub-${local.name}-prod-pri-c-01"]]
}
###################################################################
# Create a new application load balancer
###################################################################
resource "aws_alb" "alb" {
  name            = "alb-${local.name}-prod"
  security_groups = [aws_security_group.sg_alb.id]
  subnets         = "${local.alb_subent}"
  tags = {
    Name = "alb-${local.name}-prod"
  }
}


###################################################################
# Create a new target group for the application load balancer
###################################################################
resource "aws_alb_target_group" "group" {
  name     = "tg-${local.name}-was"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id 
  stickiness {
    type = "lb_cookie"
  }
  # Alter the destination of the health check to be the login page.
  health_check {
    path = "/"
    port = 80
  }
}


###################################################################
# Attach instance to target group
###################################################################
resource "aws_alb_target_group_attachment" "group-attach" {
  target_group_arn = aws_alb_target_group.group.arn
  target_id        = aws_instance.ec2_1.id
  port             = 80
}