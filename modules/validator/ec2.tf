# This `user_data` local represents what is called "user_data" in ec2.
# This poorly named variable is simply a script that is run on the
# instance when it is started. In this case, we append the name of
# the "ECS_CLUSTER" that the ec2 instance should join.
# 
# Additionally, we install "ec2-instance-connect" to enable EC2 Instance Connect.
# This allows us to SSH into the validators from the AWS Deveoper console.
# https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Connect-using-EC2-Instance-Connect.html
locals {
  user_data = <<EOH
#!/bin/bash

# Install ECS instance connect
yum update -y
yum install ec2-instance-connect -y

# Register this EC2 instance to the ECS cluster
echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config

EOH
}

# This AMI is the ECS-optimized Amazon Linux AMI.
data "aws_ami" "amazon_linux_ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = [var.ecs_task_cpu_architecture == "X86_64" ? "amzn2-ami-ecs-inf-hvm-*-x86_64-ebs" : "amzn2-ami-ecs-hvm-*-arm64-ebs"]
  }
}

# This is the EC2 instance for the validator used for ECS.
resource "aws_instance" "validator_ec2_instance" {
  ami = data.aws_ami.amazon_linux_ecs_ami.id

  instance_type          = var.ec2_instance_type
  iam_instance_profile   = aws_iam_instance_profile.validator_instance_profile.name
  vpc_security_group_ids = [aws_security_group.main.id]
  user_data              = local.user_data
  subnet_id              = aws_subnet.public[keys(aws_subnet.public)[0]].id

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

  depends_on = [aws_internet_gateway.main]
}

# Create an elastic IP and associate it with the ec2 instance.
# This ensures that the IP will remain static in the case
# that the ec2 instance needs to be destroyed and recreated.
resource "aws_eip" "validator_eip" {
  count    = var.create_validator_eip ? 1 : 0
  instance = aws_instance.validator_ec2_instance.id
  vpc      = true

  tags = {
    Name        = "${var.environment}-${var.name}-eip"
    Environment = var.environment
  }
}
