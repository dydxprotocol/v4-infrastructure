# This `user_data` local represents what is called "user_data" in ec2.
# This poorly named variable is simply a script that is run on the
# instance when it is started. In this case, we append the name of
# the "ECS_CLUSTER" that the ec2 instance should join.
# 
# Additionally, we install "ec2-instance-connect" to enable EC2 Instance Connect.
# This allows us to SSH into the host from the AWS Deveoper console.
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
    values = ["amzn2-ami-ecs-inf-hvm-*-x86_64-ebs"]
  }
}

# This is the EC2 instance for the metric ingestor used for ECS.
resource "aws_instance" "metric_ingestor_ec2_instance" {
  ami = data.aws_ami.amazon_linux_ecs_ami.id

  instance_type          = var.ec2_instance_type
  iam_instance_profile   = aws_iam_instance_profile.metric_ingestor_instance_profile.name
  vpc_security_group_ids = [aws_security_group.main.id]
  user_data              = local.user_data
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
