###################################################################
# Create a new application load balancer
###################################################################
resource "aws_alb" "alb" {
  name            = "alb-${local.name}-prod"
  security_groups = [aws_security_group.sg_alb.id]
  subnets         = "${local.alb_subnet}"
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

resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "listener_https" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ssl_certificate.arn
  default_action {
    target_group_arn = "${aws_alb_target_group.group.arn}"
    type             = "forward"
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