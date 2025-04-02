# IAM Policy Document for ECS tasks: assumes "ecs-tasks.amazonaws.com" and "export.rds.amazonaws.com"
# services. "sts:AssumeRole" allows tasks to assume an IAM role that's different from the
# one that the Amazon EC2 instance uses.
data "aws_iam_policy_document" "ecs_task_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com", "export.rds.amazonaws.com"]
    }
  }
}

# IAM Policy Document that enables "iam:PassRole". This permission is necessary
# for the update research task in `roundtable` since it allows the ECS task role
# to pass itself to the RDS service when starting an export task.
data "aws_iam_policy_document" "ecs_pass_role" {
  statement {
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.ecs_task_role.arn]
  }
}

resource "aws_iam_policy" "ecs_task_pass_role_policy" {
  name        = "${var.environment}-${var.name}-EcsTaskPassRolePolicy"
  description = "Allows ECS tasks to pass the same role when starting RDS export tasks"
  policy      = data.aws_iam_policy_document.ecs_pass_role.json

  tags = {
    Name        = "${var.environment}-${var.name}-ecs-task-pass-role-policy"
    Environment = var.environment
  }
}

# -----------------------------------------------------------------------------
# ECS task execution role: used by ECS agent to prepare the containers to run.
# -----------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_policy.json
  name               = "${var.environment}-${var.name}-EcsClusterTaskExecutionRole"

  tags = {
    Name        = "${var.environment}-${var.name}-ecs-cluster-task-execution-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "task_execution_role" {
  role = aws_iam_role.ecs_task_execution_role.name

  # AmazonECSTaskExecutionRolePolicy is needed to pull from ECR and manage logs.
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# -----------------------------------------------------------------------------
# ECS task role: used by the task itself.
# -----------------------------------------------------------------------------
resource "aws_iam_role" "ecs_task_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs_task_role_policy.json
  name               = "${var.environment}-${var.name}-EcsClusterTaskRole"

  tags = {
    Name        = "${var.environment}-${var.name}-ecs-cluster-task-role"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_pass_role" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_pass_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "task_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_exec_policy.arn
}

resource "aws_iam_role_policy_attachment" "task_role_policy_additional_attachments" {
  for_each = { for policy in var.additional_task_role_policies : policy.name => policy }

  role       = aws_iam_role.ecs_task_role.name
  policy_arn = each.value.value
}

# Enables ECS Exec for debugging of task definitions.
# See https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-exec.html
data "aws_iam_policy_document" "ecs_exec_policy_document" {
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecs_exec_policy" {
  name   = "${var.environment}-${var.name}-EcsExecPolicy"
  policy = data.aws_iam_policy_document.ecs_exec_policy_document.json

  tags = {
    Name        = "${var.environment}-${var.name}-ecs-exec-policy"
    Environment = var.environment
  }
}

data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:*:${data.aws_caller_identity.current.account_id}:log-group:/ecs/${var.name}:*"]
  }
}

resource "aws_iam_policy" "cloudwatch_logs" {
  name        = "${var.environment}-${var.name}-cloudwatch-logs"
  description = "Allow creating and writing to CloudWatch logs"
  policy      = data.aws_iam_policy_document.cloudwatch_logs.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs.arn
}

data "aws_caller_identity" "current" {}
