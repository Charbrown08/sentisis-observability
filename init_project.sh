#!/bin/bash

echo "🚀 Iniciando estructura del proyecto Sentisis Observability..."

# Crear carpetas
mkdir -p .github/workflows
mkdir -p terraform/envs
mkdir -p scripts
mkdir -p docker

# Crear archivos vacíos clave
touch .gitignore
touch README.md

# Terraform
touch terraform/main.tf
touch terraform/variables.tf
touch terraform/outputs.tf
touch terraform/backend-staging.tf
touch terraform/envs/staging.tfvars

# Script de inicialización
touch scripts/userdata.sh

# Docker
touch docker/docker-compose.yml
touch docker/prometheus.yml
touch docker/datasource.yml

# GitHub Actions (CI/CD opcional)
touch .github/workflows/deploy.yml

echo "✅ Estructura creada correctamente."
echo "📁 Puedes empezar con el archivo terraform/main.tf"
