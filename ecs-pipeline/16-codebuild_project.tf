resource "aws_codebuild_project" "repo-project" {
  name         = "${local.build_project_name}"
  service_role = "${aws_iam_role.codebuild-role.arn}"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type     = "CODECOMMIT"
    location = "${aws_codecommit_repository.repo.clone_url_http}"
    buildspec = local.buildspec_location
  }
  source_version = local.source_version

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "AWS_REGION"
      value = "ap-northeast-2"
    }

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = "759320821027"
    }

    environment_variable {
      name  = "IMAGE_NAME"
      value = "nodehelloworld"
    }

    environment_variable {
      name  = "IMAGE_TAG"
      value = "0.1"
    }

  }
}