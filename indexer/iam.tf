# Module for ECS task and task execution roles
module "iam_service_ecs_task_roles" {
  for_each    = local.service_names
  source      = "../modules/iam/ecs_task_roles"
  name        = "${var.indexers[var.region].name}-${each.key}"
  environment = var.environment
  additional_task_role_policies = flatten(
    [
      local.indexer_ecs_task_role_policies,
      [{
        "name"  = "ECS tasks secrets access",
        "value" = aws_iam_policy.ecs_task_secrets_access[each.key].arn,
      }],
    ],
  )
}

// Legacy, delete after all environments have been migrated to using per task ECS roles.
// Needed as existing running ECS tasks depend on this ECS role.
module "iam_ecs_task_roles" {
  source                        = "../modules/iam/ecs_task_roles"
  name                          = var.indexers[var.region].name
  environment                   = var.environment
  additional_task_role_policies = local.indexer_ecs_task_role_policies
}

# -----------------------------------------------------------------------------
# Secrets access for each service
# -----------------------------------------------------------------------------

data "aws_iam_policy_document" "secrets_access" {
  for_each = local.service_secret_ids
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
    ]
    resources = [
      "arn:aws:secretsmanager:${var.region}:${local.account_id}:secret:${each.value}*"
    ]
  }

  statement {
    actions = [
      "secretsmanager:ListSecrets",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_task_secrets_access" {
  for_each    = data.aws_iam_policy_document.secrets_access
  name        = "${var.environment}-${each.key}-ecs_task_secrets_access"
  description = "Allows ${each.key} ECS task to access secrets in secrets manager"

  policy = each.value.json
}

# -----------------------------------------------------------------------------
# Lambda Services task roles: used by the lambda task itself.
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "lambda_services_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# IAM role to be used by lambda_services
resource "aws_iam_role" "lambda_services" {
  for_each = local.lambda_services

  name = "${var.environment}-${var.indexers[var.region].name}-${each.key}"

  assume_role_policy = data.aws_iam_policy_document.lambda_services_role_policy.json
}

# Attach the lambda service's deploy policy to lambda service's IAM role
resource "aws_iam_role_policy_attachment" "lambda_services_deploy_policy_attachment" {
  for_each = local.lambda_services

  role       = aws_iam_role.lambda_services[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Attach the lambda service's policy for upgrading indexer
resource "aws_iam_role_policy_attachment" "lambda_services_upgrade_indexer_attachment" {
  for_each = { for key, value in local.lambda_services : key => value if value.requires_upgrade_indexer_iam_policies }

  role       = aws_iam_role.lambda_services[each.key].name
  policy_arn = aws_iam_policy.lambda_upgrade_indexer_policy.arn
}

resource "aws_iam_policy" "lambda_upgrade_indexer_policy" {
  name        = "UpdateIndexerPolicy"
  description = "Policy that grants permission necessary to upgrade indexer"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "lambda:UpdateFunctionCode",
          "lambda:InvokeFunction",
          "lambda:GetFunction",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService",
          "iam:PassRole",
          "ecr:DescribeImages"
        ],
        Effect = "Allow",
        // TODO(IND-262): Restrict these permissions
        Resource = "*"
      }
    ]
  })
}
