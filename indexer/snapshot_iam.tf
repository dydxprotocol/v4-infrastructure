locals {
  snapshot_bucket_name = var.environment == "mainnet" ? "${local.account_id}-${var.s3_snapshot_bucket}" : var.s3_snapshot_bucket
}

data "aws_iam_policy_document" "ecs_task_s3_policy" {
  statement {
    sid = "SnapshotObjectRW"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
    ]

    resources = ["arn:aws:s3:::${local.snapshot_bucket_name}/*"]
  }

  statement {
    sid       = "SnapshotBucketList"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${local.snapshot_bucket_name}"]
  }
}

resource "aws_iam_policy" "ecs_task_s3_policy" {
  name        = "${var.environment}-${var.indexers[var.region].name}-ecs_task_s3_policy"
  description = "Allows ECS tasks to access S3"

  policy = data.aws_iam_policy_document.ecs_task_s3_policy.json
}
