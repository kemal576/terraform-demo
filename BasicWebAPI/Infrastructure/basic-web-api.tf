terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-00f07845aed8c0ee7"
  instance_type = "t2.micro"
  key_name      = "EC2_KEY" # EC2 SSH key's name on aws

  user_data = var.docker_installation_script

  tags = {
    Name = "BasicWebAPI_ServerInstance"
  }

  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
}

resource "aws_security_group" "app_server_sg" {
  name        = "allow_ssh_http"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH için tüm IP'lere izin ver
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HTTP için tüm IP'lere izin ver
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Dışa çıkış trafiğine tüm portlardan izin ver
  }
}

output "public_ip" {
  description = "EC2 instance public IP"
  value       = aws_instance.app_server.public_ip
}

