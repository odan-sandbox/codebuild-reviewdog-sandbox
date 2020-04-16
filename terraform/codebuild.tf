
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  name = "codebuild-reviewdog-sandbox-role"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_codebuild_project" "ci" {
  name = "codebuild-reviewdog-sandbox"

  service_role = aws_iam_role.role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/odan-sandbox/codebuild-reviewdog-sandbox"
    git_clone_depth = 1
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }
}
