# Datadog agent 
The module contains the container definition for datadog agent sidecar. The output is meant to be used in the container definitions of aws_ecs_task_definition resource. 

## Configuration

The datadog sidecar container definition is setup based on [Datadog prometheus docker doc](https://docs.datadoghq.com/containers/docker/prometheus/?tabs=standard).

The datadog agent scrapes the `/metrics` endpoint at regular intervals and searches for specific docker labels.

```terraform
labels:
  com.datadoghq.ad.check_names: '["openmetrics"]'
  com.datadoghq.ad.init_configs: '[{}]'
  com.datadoghq.ad.instances: |
    [
      {
        "openmetrics_endpoint": "http://%%host%%:1317/metrics?format=prometheus",
        "namespace": "dydxprotocol",
        "metrics": [
          ".*"
        ]
      }
    ]    
```

## Example usage

The container definition can be plugged in directly to `container_definitions` in `aws_ecs_task_definition` resource: 
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#example-usage

```terraform
resource "aws_ecs_task_definition" "service" {
  family = "service"
  container_definitions = jsonencode([
    {
      ...
    },
    module.datadog_agent.container_definition
  ])
  ...
}
```
