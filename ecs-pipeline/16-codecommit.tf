resource "aws_codecommit_repository" "repo" {
  repository_name = local.codecommit_repo_name
}