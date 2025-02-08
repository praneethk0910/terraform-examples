provider "aws" {
  region = "us-east-1"
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get default Subnets
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

# Security Group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow SSH and HTTP access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Launch Configuration
resource "aws_launch_configuration" "example" {
  name          = "example-launch-configuration"
  image_id      = "ami-0c55b159cbfafe1f0"  # Replace with your preferred AMI ID
  instance_type = "t2.micro"
  security_groups = [aws_security_group.ec2_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "example" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids
  launch_configuration = aws_launch_configuration.example.id

  tag {
    key                 = "Name"
    value               = "auto-scaling-instance"
    propagate_at_launch = true
  }

  health_check_type          = "EC2"
  health_check_grace_period = 300
  wait_for_capacity_timeout  = "0"

}

# Target Tracking Scaling Policy
resource "aws_autoscaling_policy" "example" {
  name                   = "example-target-tracking-policy"
  autoscaling_group_name = aws_autoscaling_group.example.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    target_value = 50.0  # Target CPU utilization (50% in this case)
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
}
