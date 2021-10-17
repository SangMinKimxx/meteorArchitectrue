resource "aws_codepipeline" "codepipeline" {
  name     = "meteor-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline_bucket.bucket
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      output_artifacts = ["${var.app}"]
      version          = "1"
      configuration = {
        Owner                = "${var.github_org}"
        Repo                 = "${var.project}"
        PollForSourceChanges = "true"
        Branch               = "main"
        OAuthToken           = "${var.github_token}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["${var.app}"]
      output_artifacts  = ["${var.production}"]
      version          = "1"

      configuration ={
        ProjectName ="${var.project}-CodeBuild"
      }
    }
  }

  stage {
    name = "Approve"

    action {
      name     = "Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["${var.production}"]
      version         = "1"

      configuration ={
        ProjectName = "${var.project}-CodeBuild-Deploy"
      }
    }
  }
  
}

