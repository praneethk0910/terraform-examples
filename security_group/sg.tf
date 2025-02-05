provider "aws" {
  region = "us-east-1"
}

# Security Group for EC2 instances
resource "aws_security_group" "basic_sg" {
  name        = "basic-sg"
  description = "Allow SSH, HTTP, and ICMP traffic"

  # Inbound SSH Rule (Allow SSH from anywhere)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound HTTP Rule (Allow HTTP from anywhere)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound ICMP Rule (Allow ping from anywhere)
  ingress {
    from_port   = -1   # ICMP uses -1 for both source and destination ports
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rule (Allow all outbound traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 allows all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "basic-security-group"
  }
}
