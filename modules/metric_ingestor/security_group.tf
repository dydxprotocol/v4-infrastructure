# Security group for the network.
resource "aws_security_group" "main" {
  name   = "${var.environment}-${var.name}-sg"
  vpc_id = aws_vpc.main.id

  # Allow port 22 for "ec2-instance-connect".
  # This allows us to SSH into the hosts from the AWS Deveoper console.
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Connect-using-EC2-Instance-Connect.html
  ingress {
    protocol         = "tcp"
    from_port        = 22
    to_port          = 22
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # For outgoing traffic, allow all.
  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.environment}-${var.name}-sg"
    Environment = var.environment
  }
}
