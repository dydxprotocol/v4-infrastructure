# Outputs the ARN of the task execution role
output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

# Outputs the ARN of the task role
output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}
