
resource "aws_codebuild_project" "project" {
  name          = "${var.project}-CodeBuild"
  description   = "${var.project} CodeBuild Project"
  build_timeout = "10"
  service_role  = "${aws_iam_role.tf_codebuild_role.arn}"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "${var.docker_build_image}"
    type         = "LINUX_CONTAINER"
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildSpec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}

resource "aws_codebuild_project" "deploy_dev" {
  name          = "${var.project}-CodeBuild-Deploy"
  description   = "${var.project} CodeBuild Project Deploy Dev"
  build_timeout = "12"
  service_role  = "${aws_iam_role.tf_codebuild_role.arn}"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "${var.docker_build_image}"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "ENVIRONMENT"
      value = "dev"
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "buildSpec_deploy.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}
