# Basic policy document to allow AWS to manage KMS key.
# TODO(CLOB-671): Limit AWS permissions for managing KMS keys.
data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

# KMS key for RDS export tasks.
resource "aws_kms_key" "rds_export" {
  count                   = var.indexer_enabled ? 1 : 0
  description             = "KMS key for RDS export tasks"
  deletion_window_in_days = 7
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
}

# Policy document to allow ECS task role to use KMS key for RDS export tasks. Link to required
# permissions: https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_StartExportTask.html
data "aws_iam_policy_document" "kms_permissions" {
  count      = var.indexer_enabled ? 1 : 0
  depends_on = [aws_kms_key.rds_export[0]]

  statement {
    actions = [
      "kms:CreateKey",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyWithoutPlaintext",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo",
      "kms:CreateGrant",
      "kms:DescribeKey",
      "kms:RetireGrant",
    ]

    resources = [aws_kms_key.rds_export[0].arn]
  }
}

# IAM policy that will be attached to ECS task role to use KMS key for RDS export tasks.
resource "aws_iam_policy" "kms_policy" {
  count       = var.indexer_enabled ? 1 : 0
  name        = "kmsPolicy"
  description = "A policy that provides KMS actions"
  policy      = data.aws_iam_policy_document.kms_permissions[0].json
}
