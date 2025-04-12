# Región donde se desplegará la infraestructura (ej. us-east-1)
variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}

# AMI ID para lanzar la instancia (Amazon Linux 2 recomendado)
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

# Tipo de instancia EC2
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
}

# ID del par de claves SSH creado en AWS
variable "key_name" {
  description = "Name of the SSH key pair to access the instance"
  type        = string
}

# ID de la VPC donde se lanzará la EC2
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

# ID de la subred donde se ubicará la instancia
variable "subnet_id" {
  description = "ID of the subnet to launch the EC2 instance in"
  type        = string
}

# Lista de IPs permitidas para conectarse (ej. ["0.0.0.0/0"])
variable "allowed_ips" {
  description = "List of CIDR blocks allowed to access the instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# Nombre del proyecto o prefijo para los recursos
variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

# Entorno (staging, production, etc)
variable "environment" {
  description = "Environment name for tagging purposes"
  type        = string
}

# Nombre del secreto de Grafana en Secrets Manager
variable "password_secret_name" {
  description = "Name of the Grafana secret in Secrets Manager"
  type        = string
}
