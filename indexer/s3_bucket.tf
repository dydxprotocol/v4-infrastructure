# AWS S3 bucket to store all load balancer logs
resource "aws_s3_bucket" "load_balancer" {
  bucket        = "${local.account_id}-${var.environment}-${var.indexers[var.region].name}-lb-public-logs"
  force_destroy = true

  tags = {
    Name        = "${local.account_id}-${var.environment}-${var.indexers[var.region].name}-lb-public-logs"
    Environment = var.environment
  }
}

# TODO: refactor snapshotting full node into a separate module
# AWS S3 bucket to store all Indexer full node snapshots
resource "aws_s3_bucket" "indexer_full_node_snapshots" {
  # Use account id for mainnet to avoid name collisions
  # TODO(IND-457): Migrate files in other envs and update bucket name
  bucket = var.environment == "mainnet" ? "${local.account_id}-${var.s3_snapshot_bucket}" : var.s3_snapshot_bucket

  tags = {
    Name        = "${local.account_id}-${var.environment}-full-node-snapshots"
    Environment = var.environment
  }
}

# Enable S3 bucket metrics to be sent to Datadog for monitoring
resource "aws_s3_bucket_metric" "indexer_full_node_snapshots" {
  bucket = aws_s3_bucket.indexer_full_node_snapshots.id
  name   = "EntireBucket"
}

# Attach policy to s3 bucket to allow load balancer to write logs to the S3 bucket
# NOTE: This resource cannot be tagged.
resource "aws_s3_bucket_policy" "lb_s3_bucket_policy" {
  bucket = aws_s3_bucket.load_balancer.id
  policy = data.aws_iam_policy_document.lb_s3_bucket_policy.json
}

# Policy to allow load balancer to write logs into the s3 bucket
data "aws_iam_policy_document" "lb_s3_bucket_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = [var.indexers[var.region].elb_account_id]
    }

    actions = [
      "s3:PutObject"
    ]

    resources = [
      aws_s3_bucket.load_balancer.arn,
      "${aws_s3_bucket.load_balancer.arn}/*"
    ]
  }
}

# AWS S3 bucket to store RDS snapshots, used as data sources for Athena.
resource "aws_s3_bucket" "athena_rds_snapshots" {
  bucket        = "${local.account_id}-${var.environment}-${var.indexers[var.region].name}-athena-rds-snapshots"
  force_destroy = true

  tags = {
    Name        = "${local.account_id}-${var.environment}-${var.indexers[var.region].name}-athena-rds-snapshots"
    Environment = var.environment
  }
}
