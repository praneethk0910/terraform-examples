terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# EC2 instance
resource "aws_instance" "web" {
  ami = "ami-0ac4dfaf1c5c0cce9" # Amazon Linux - us-east-1
  # ami-0eb070c40e6a142a3 - Amazon Linux - us-east-2
  instance_type = "t2.micro"
}