module "iam_github_actions" {
  source      = "../modules/iam/github_actions_role"
  name        = var.indexers[var.region].name
  environment = var.environment
  ecr_repository_arns = concat(
    [for repository in aws_ecr_repository.main : repository.arn],
    [for repository in aws_ecr_repository.lambda_services : repository.arn],
  )
  lambda_arns = [
    "arn:aws:lambda:us-east-2:${local.account_id}:function:orb_lambda_function",
  ]
  assume_iam_roles = [
    "arn:aws:iam::${local.account_id}:role/${var.environment}-orb-lambda-role",
  ]
}
