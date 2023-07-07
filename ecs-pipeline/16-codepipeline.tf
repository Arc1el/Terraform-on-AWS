resource "aws_codepipeline" "pipeline" {
  name     = local.pipline_name
  role_arn = "${data.aws_iam_role.pipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.bucket-artifact.bucket}"
    type     = "S3"
  }
  # SOURCE
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = "${local.codecommit_repo_name}"
        BranchName     = "${local.branch_name}"
      }
    }
  }
  # BUILD
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = "${local.build_project_name}"
      }
    }
  }
  # DEPLOY
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      version         = "1"
      input_artifacts = ["build_output"]

      configuration = {
        ClusterName = local.esc_cluster_name
        ServiceName = local.ecs_service_name
        FileName    = local.imagedefinition_path
      }
    }
  }
}

data "aws_iam_role" "pipeline_role" {
  name = "codepipeline-role"
}

data "aws_iam_role" "ecs-task" {
  name = "ecsTaskExecutionRole"
}

output "repo_url" {
  value = aws_codecommit_repository.repo.clone_url_http
}

output "alb_dns" {
  value = aws_lb.app-lb.dns_name
}