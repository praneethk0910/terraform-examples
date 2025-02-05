provider "aws" {
  region = "us-west-2"
}

resource "aws_elastic_beanstalk_application" "example" {
  name        = "example-app"
  description = "Elastic Beanstalk application for Node.js"
}

resource "aws_elastic_beanstalk_environment" "example" {
  name                = "example-env"
  application         = aws_elastic_beanstalk_application.example.name
  solution_stack_name = "64bit Amazon Linux 2 v3.3.6 running Node.js 14"

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "3"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "example-nodejs-app-bucket"
}
