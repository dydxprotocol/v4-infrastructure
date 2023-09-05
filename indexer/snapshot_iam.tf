data "aws_iam_policy_document" "ecs_task_s3_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_task_s3_policy" {
  name        = "${var.environment}-${var.indexers[var.region].name}-ecs_task_s3_policy"
  description = "Allows ECS tasks to access S3"

  policy = data.aws_iam_policy_document.ecs_task_s3_policy.json
}
