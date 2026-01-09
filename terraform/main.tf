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

provider "aws" {
  region = "eu-central-1"
}

variable "ssh_public_key" {
  description = "Public SSH key for EC2 access"
  type        = string
}

resource "aws_key_pair" "deploy_key" {
  key_name   = "github-actions-deploy-key"
  public_key = var.ssh_public_key
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

  ingress {
    from_port   = 9090
    to_port     = 9090
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

  key_name = aws_key_pair.deploy_key.key_name

  tags = {
    Name = "webapp_instance"
  }
}

output "instance_public_ip" {
  value     = aws_instance.webapp_instance.public_ip
  sensitive = true
}
