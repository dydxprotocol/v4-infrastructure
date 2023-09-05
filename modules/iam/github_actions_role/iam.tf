# This group represents a group for the Github Actions IAM role.
# The permissions this group has should enable Github Actions to automatically push up ECR images or
# deploy lambdas.
resource "aws_iam_group" "github_actions_iam_group" {
  name = "${var.environment}-${var.name}-GithubActionsIamGroup"
}

data "aws_iam_policy_document" "ecr_push_pull_policy_document" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]

    # From the documentation here 
    # https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazonelasticcontainerregistry.html
    # `GetAuthorizationToken` can't be restricted further than all resources or `*`.
    resources = ["*"]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [
      "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:public-testnet-node-keys-*",
      "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:public-testnet-mnemonics-*",
    ]
  }

  dynamic "statement" {
    for_each = length(var.lambda_arns) > 0 ? local.lambda_exists : []

    content {
      actions = [
        "s3:PutObject",
        "iam:ListRoles",
        "lambda:UpdateFunctionCode",
        "lambda:CreateFunction",
        "lambda:UpdateFunctionConfiguration",
        "lambda:InvokeFunction",
        "lambda:GetFunction"
      ]

      resources = var.lambda_arns
    }
  }

  dynamic "statement" {
    for_each = length(var.s3_bucket_arns) > 0 ? local.s3_exists : []

    content {
      actions = [
        "s3:PutObject",
      ]

      resources = var.s3_bucket_arns
    }
  }

  dynamic "statement" {
    for_each = length(var.assume_iam_roles) > 0 ? local.iam_role_exists : []

    content {
      actions = [
        "iam:GetRole",
        "sts:AssumeRole",
      ]

      resources = var.assume_iam_roles
    }
  }

  dynamic "statement" {
    for_each = length(var.ecr_repository_arns) > 0 ? local.ecr_exists : []

    content {
      actions = [
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:CompleteLayerUpload",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ]

      resources = var.ecr_repository_arns
    }
  }
}

resource "aws_iam_policy" "github_actions_policy" {
  name   = "${var.environment}-${var.name}-GithubActionsPolicy"
  policy = data.aws_iam_policy_document.ecr_push_pull_policy_document.json

  tags = {
    Name        = "${var.environment}-${var.name}-GithubActionsPolicy"
    Environment = var.environment
  }
}

resource "aws_iam_group_policy_attachment" "github_actions_policy_attachment" {
  group      = aws_iam_group.github_actions_iam_group.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}

# This user is used to create an AWS_ACCESS_KEY and AWS_SECRET_ACCESS_KEY for
# GitHub actions.
# This user has the following permissions:
# - pushing up new ECR images to a list of ECR repositories given as an input variable
# - deploying a list of Lambdas given as an input variable
# The allows for creating Github actions to automatically push up ECR images or deploying lambdas
# whenever a commit is merged in a relevant Github repository.
resource "aws_iam_user" "github_actions_iam_user" {
  name = "${var.environment}-${var.name}-github-actions"

  tags = {
    Name        = "${var.environment}-${var.name}-github-actions"
    Environment = var.environment
  }
}

resource "aws_iam_group_membership" "ecr_push_pull_iam_group_membership" {
  name = "${var.environment}-${var.name}-GithubActionsIamGroupMembership"

  users = [
    aws_iam_user.github_actions_iam_user.name,
  ]

  group = aws_iam_group.github_actions_iam_group.name
}
