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

output "datadog_cpu" {
  value       = var.container_cpu_units
  description = "The number of cpu units to reserve for the datadog agent container."
}

output "datadog_memory" {
  value       = var.container_memory_reservation
  description = "The amount of memory (in MiB) to reserve for the datadog agent container."
}
