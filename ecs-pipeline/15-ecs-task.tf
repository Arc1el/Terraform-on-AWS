resource "aws_ecs_task_definition" "task" {
  family                   = "HTTPserver"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = data.aws_iam_role.ecs-task.arn

  container_definitions = jsonencode([
    {
      name   = "${local.container_name}",
      image  = "${local.ecr_uri_repo}:0.1" #URI
      cpu    = 256
      memory = 512
      portMappings = [
        {
          containerPort = 3000
        }
      ]
    }
  ])
}