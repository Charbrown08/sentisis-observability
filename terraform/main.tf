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
  region = var.aws_region

}


module "secrets_manager" {
  source           = "./modules/secrets-manager"
  grafana_password = var.password_secret_name

}
module "iam_role" {
  source             = "./modules/iam-role-secrets"
  grafana_secret_arn = module.secrets_manager.grafana_secret_arn
}

resource "aws_security_group" "observability_sg" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH, Prometheus and Grafana ports"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = var.allowed_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

resource "aws_instance" "observability_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.observability_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  user_data                   = file("${path.module}/../scripts/userdata.sh")

  iam_instance_profile = module.iam_role.instance_profile_name

  tags = {
    Name        = "${var.project_name}-ec2"
    environment = var.environment
  }
}
