resource "aws_ecs_service" "svc" {
  name            = local.ecs_service_name
  cluster         = "${aws_ecs_cluster.ecs-cluster.id}"
  task_definition = "${aws_ecs_task_definition.task.id}"
  desired_count   = 2
  launch_type     = "FARGATE"


  network_configuration {
    subnets          = [module.vpc.subnet_id["01.sub-${local.name}-prod-pub-a-01"],
                        module.vpc.subnet_id["02.sub-${local.name}-prod-pub-c-01"]]
    security_groups  = ["${aws_security_group.sg1.id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.tg-group.arn}"
    container_name   = local.container_name
    container_port   = "3000"
  }
}
resource "aws_security_group" "sg1" {
  name        = "security group for portnum 3000"
  description = "Port 3000"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "Allow Port 3000"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}