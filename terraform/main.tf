terraform {
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "gomelskyi-lab6"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "lab6-my-tf-lockid"
  }
}

# Configure the AWS provider
provider "aws" {
  region = "eu-central-1"
}

variable "REPOSITORY_URI" {
  type = string
}

resource "aws_security_group" "web_app" {
  name        = "web_app"
  description = "security group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "web_app"
  }
}

resource "aws_instance" "webapp_instance" {
  ami                    = "ami-0030bb9626529d09d"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_app.id]

  tags = {
    Name = "webapp_instance"
  }
}

output "instance_public_ip" {
  value     = aws_instance.webapp_instance.public_ip
  sensitive = true
}

resource "aws_lightsail_container_service" "flask_application" {
  name  = "flask-app"
  power = "nano"
  scale = 1

  private_registry_access {
    ecr_image_puller_role {
      is_active = true
    }
  }

  tags = {
    version = "1.0.0"
  }
}

resource "aws_lightsail_container_service_deployment_version" "flask_app_deployment" {
  container {
    container_name = "flask-application"
    image          = "${var.REPOSITORY_URI}:latest"
  }

  ports = {
    80 = "HTTP"
  }

  public_endpoint {
    container_name = "flask-application"
    container_port = 8080

    health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout_seconds     = 2
      interval_seconds    = 10
      path                = "/"
      success_codes       = "200-499"
    }
  }
  
  service_name = aws_lightsail_container_service.flask_application.name
  
}
