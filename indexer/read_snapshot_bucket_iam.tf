data "aws_iam_policy_document" "read_snapshot_bucket_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.indexer_full_node_snapshots.arn,
    ]
  }
}

# IAM role to be used by Datadog for snapshot s3 bucket monitoring
resource "aws_iam_role" "read_snapshot_bucket_role" {
  name               = "read_snapshot_bucket_role"
  assume_role_policy = data.aws_iam_policy_document.read_snapshot_bucket_policy.json
}

