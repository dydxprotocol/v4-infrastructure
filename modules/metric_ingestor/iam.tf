module "iam_ecs_task_roles" {
  source      = "../iam/ecs_task_roles"
  name        = var.name
  environment = var.environment
}

# -----------------------------------------------------------------------------
# ECS instance role: used by an ec2 instance to support joining an ECS cluster
# -----------------------------------------------------------------------------
data "aws_iam_policy_document" "ecs_instance_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_instance_iam_role" {
  name               = "${var.environment}-${var.name}-EcsInstanceRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_policy_document.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy_attachment" {
  role       = aws_iam_role.ecs_instance_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "metric_ingestor_instance_profile" {
  name = "${var.environment}-${var.name}-ValidatorMonitorInstanceProfile"
  role = aws_iam_role.ecs_instance_iam_role.name
}
