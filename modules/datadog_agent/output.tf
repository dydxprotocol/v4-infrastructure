output "ecs_fargate_container_definition" {
  value       = local.ecs_fargate_container_definition
  description = "container definition for Datadog sidecar for ECS fargate"
}

output "ecs_ec2_container_definition" {
  value       = local.ecs_ec2_container_definition
  description = "container definition for Datadog sidecar for ECS EC2"
}

output "ecs_ec2_container_volumes" {
  value       = local.ecs_ec2_container_volumes
  description = "container volumes for Datadog sidecar for ECS EC2"
}
