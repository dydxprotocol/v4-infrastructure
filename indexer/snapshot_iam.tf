data "aws_iam_policy_document" "ecs_task_s3_policy" {
  statement {
    sid = "SnapshotObjectRW"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
    ]

    resources = ["${aws_s3_bucket.indexer_full_node_snapshots.arn}/*"]
  }

  statement {
    sid       = "SnapshotBucketList"
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.indexer_full_node_snapshots.arn]
  }
}

resource "aws_iam_policy" "ecs_task_s3_policy" {
  name        = "${var.environment}-${var.indexers[var.region].name}-ecs_task_s3_policy"
  description = "Allows ECS tasks to access S3"

  policy = data.aws_iam_policy_document.ecs_task_s3_policy.json
}
