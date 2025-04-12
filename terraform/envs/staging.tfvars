# Región AWS donde quieres desplegar (us-east-1 es N. Virginia)
aws_region = "us-east-1"

# AMI ID para Amazon Linux 2 en us-east-1 (verifica en tu consola AWS)
ami_id = "ami-07a6f770277670015"

# Tipo de instancia
instance_type = "t3.micro"

# Nombre del par de claves SSH que ya creaste en AWS
key_name = "sentisis-key"

# VPC ID y Subnet ID donde vas a desplegar (consulta en tu consola AWS)
vpc_id    = "vpc-00691247b0077b8a5"
subnet_id = "subnet-093e2bb009a3a47ac"

# Lista de IPs permitidas (puedes dejarlo abierto para pruebas)  Cambia a tu IP pública si quieres más seguridad
allowed_ips = ["0.0.0.0/0"]

# Prefijo para nombrar recursos
project_name = "sentisis-staging"

# Entorno para etiquetas
environment = "staging"

# Nombre del secreto de Grafana en Secrets Manager
password_secret_name = "grafana/staging"
