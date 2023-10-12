module "iam_ecs_task_roles" {
  source      = "../iam/ecs_task_roles"
  name        = var.name
  environment = var.environment
}

data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

# -----------------------------------------------------------------------------
# ECS instance role: used by an ec2 instance to support joining an ECS cluster
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "ecs_instance_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_instance_iam_role" {
  name               = "${var.environment}-${var.name}-EcsInstanceRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy_attachment" {
  role       = aws_iam_role.ecs_instance_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "metric_ingestor_instance_profile" {
  name = "${var.environment}-${var.name}-ValidatorMonitorInstanceProfile"
  role = aws_iam_role.ecs_instance_iam_role.name
}

# Policy to allow the role to list tags on ECS resources.
# Prevents polluting the logs with: "Task Metadata error: unable to get 'ContainerInstanceTags'/'TaskTags'"

data "aws_iam_policy_document" "ecs_list_tags_policy_document" {
  statement {
    actions = ["ecs:ListTagsForResource"]

    resources = [
      "arn:aws:ecs:*:${local.aws_account_id}:container-instance/*/*",
      "arn:aws:ecs:*:${local.aws_account_id}:task/*/*",
    ]
  }
}

resource "aws_iam_policy" "ecs_list_tags_policy" {
  name        = "ecs-list-tags-policy"
  description = "A policy that allows to list tags on ECS resources"
  policy      = data.aws_iam_policy_document.ecs_list_tags_policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecs_list_tags" {
  role       = aws_iam_role.ecs_instance_iam_role.name
  policy_arn = aws_iam_policy.ecs_list_tags_policy.arn
}
