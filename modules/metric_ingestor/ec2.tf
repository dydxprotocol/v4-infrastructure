# We use Cloud Init to provision the initial state of our EC2. See:
# - https://cloudinit.readthedocs.io/
# - https://stackoverflow.com/a/72179536
#
# Our setup does the following:
# 1) Script: append the name of the "ECS_CLUSTER" that the ec2 instance
# should join.
# 2) File provisioning: copy the custom check definition for Endpoint Checker.
# These EC2-based directory structure will be referenced by the ECS task
# as volumes and serve to configure the Datadog Agent.
#
# For Datadog custom checks see: 
# - https://docs.datadoghq.com/metrics/custom_metrics/agent_metrics_submission/
# - https://docs.datadoghq.com/developers/custom_checks/write_agent_check/

locals {
  startup_script = <<EOH
#!/bin/bash

# Register this EC2 instance to the ECS cluster
echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config

# Create directory structure for custom checks. The files will be created
# by write_files in the cloudinit_config resource.
mkdir -p /endpoint-checker/checks.d
mkdir -p /endpoint-checker/conf.d
EOH
}

data "cloudinit_config" "init" {
  part {
    content_type = "text/x-shellscript"
    content      = local.startup_script
  }

  part {
    content_type = "text/cloud-config"
    content = yamlencode({
      write_files = [
        {
          encoding = "b64"
          content  = filebase64("${path.module}/endpoint_checker.py")
          path     = "/endpoint-checker/checks.d/endpoint_checker.py"
        },
        {
          encoding = "b64"
          content = base64encode(yamlencode({
            init_config = {
              # (Datadog setting) seconds to wait between collecting metrics
              # for a single instance
              min_collection_interval = 600

              # Custom settings:
              env     = var.environment
              timeout = 15 # seconds to wait for a response from each endpoint          
            }
            instances = var.validators
          }))
          path = "/endpoint-checker/conf.d/endpoint_checker.yaml"
        },
      ]
    })
  }
}

# This AMI is the ECS-optimized Amazon Linux AMI.
data "aws_ami" "amazon_linux_ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-inf-hvm-*-x86_64-ebs"]
  }
}

# This is the EC2 instance for the metric ingestor used for ECS.
resource "aws_instance" "metric_ingestor_ec2_instance" {
  ami = data.aws_ami.amazon_linux_ecs_ami.id

  instance_type          = var.ec2_instance_type
  iam_instance_profile   = aws_iam_instance_profile.metric_ingestor_instance_profile.name
  vpc_security_group_ids = [aws_security_group.main.id]
  user_data              = data.cloudinit_config.init.rendered
  subnet_id              = aws_subnet.public.id

  root_block_device {
    volume_size           = var.root_block_device_size
    delete_on_termination = var.root_block_device_delete_on_termination
    tags = {
      Name        = "${var.environment}-${var.name}-ebs-volume"
      Environment = var.environment
    }
  }

  # Enable EC2 detailed monitoring.
  # https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/cloudwatch-metrics-basic-detailed.html
  monitoring = true

  tags = {
    Name        = "${var.environment}-${var.name}-ec2"
    Environment = var.environment
  }

  lifecycle {
    ignore_changes = [
      # Ignore changes to ami. These are updated frequently
      # and cause the EC2 instance to be destroyed with
      # new deploys.
      ami,
    ]
  }
}

# Create an elastic IP and associate it with the ec2 instance.
# This ensures that the IP will remain static in the case
# that the ec2 instance needs to be destroyed and recreated.
resource "aws_eip" "metric_ingestor_eip" {
  instance = aws_instance.metric_ingestor_ec2_instance.id
  vpc      = true

  tags = {
    Name        = "${var.environment}-${var.name}-eip"
    Environment = var.environment
  }
}
