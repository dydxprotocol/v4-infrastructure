data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.market_metadata_bucket.arn,
      "${aws_s3_bucket.market_metadata_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "lambda_permissions_policy" {
  name        = "market-metadata-lambda-permissions-policy"
  description = "Permissions policy for the Market Metadata Service Lambda functions"
  policy      = data.aws_iam_policy_document.lambda_permissions.json
}

resource "aws_iam_role" "lambda_executor" {
  name                = "market-metadata-service-LambdaExecutionRole"
  assume_role_policy  = data.aws_iam_policy_document.lambda_assume_role.json
  managed_policy_arns = [aws_iam_policy.lambda_permissions_policy.arn]
}
