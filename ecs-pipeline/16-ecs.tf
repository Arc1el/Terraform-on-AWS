resource "aws_ecs_cluster" "ecs-cluster" {
  name = local.esc_cluster_name
}
