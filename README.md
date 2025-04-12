# Sentisis Sysadmin Challenge

Este proyecto implementa un stack de observabilidad utilizando **Prometheus** y **Grafana** desplegados en una instancia EC2 de AWS. La infraestructura se gestiona con **Terraform/OpenTofu**, y el despliegue automatizado se realiza mediante **GitHub Actions**.

---

## Tabla de Contenidos

- [Sentisis Sysadmin Challenge](#sentisis-sysadmin-challenge)
  - [Tabla de Contenidos](#tabla-de-contenidos)
  - [Descripción General](#descripción-general)
  - [Requisitos Previos](#requisitos-previos)
  - [Estructura del Proyecto](#estructura-del-proyecto)
- [Inicializar el proyecto](#inicializar-el-proyecto)
- [Revisar el plan de despliegue](#revisar-el-plan-de-despliegue)
- [Aplicar el plan de infraestructura](#aplicar-el-plan-de-infraestructura)

---

## Descripción General

El objetivo de este proyecto es desplegar un stack de observabilidad que incluye:

- **Prometheus**: Para recopilar métricas del sistema y de los servicios.
- **Grafana**: Para visualizar dashboards con métricas recolectadas.
- **Node Exporter**: Para exponer métricas de la instancia EC2.

El despliegue contempla:

1. Una instancia EC2 (Ubuntu o Amazon Linux).
2. Un Security Group que permite acceso controlado a puertos 22 (SSH), 3000 (Grafana) y 9090 (Prometheus).
3. Contenedores Docker para Prometheus, Grafana y Node Exporter levantados vía `docker-compose`.
4. Almacenamiento opcional de credenciales en AWS Secrets Manager.
5. Soporte para múltiples entornos (ej. `staging`, `production`).

---

## Requisitos Previos

Antes de comenzar, asegúrate de tener:

- ✅ Cuenta de AWS activa con permisos para EC2, IAM, Secrets Manager.
- ✅ Clave SSH pública cargada en AWS para acceso remoto a la instancia.
- ✅ **Terraform** o **OpenTofu** instalado localmente.
- ✅ **AWS CLI** configurado (`aws configure`).
- ✅ Secrets configurados en GitHub Actions:
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `GOOGLE_CHAT_WEBHOOK_URL` (opcional para notificaciones)

---

## Estructura del Proyecto

```plaintext
├── .github/
│   └── workflows/
│       └── deploy.yml         # Pipeline de despliegue CI/CD con validaciones DevSecOps
├── scripts/
│   └── userdata.sh            # Script de arranque de EC2 que lanza Docker y los contenedores
├── terraform/
│   ├── main.tf                # Infraestructura principal (EC2, SG, etc.)
│   ├── variables.tf           # Definición de variables
│   ├── outputs.tf             # Salidas útiles como IP pública
│   ├── envs/
│   │   ├── staging.tfvars     # Variables específicas para staging
│   │   └── production.tfvars  # Variables específicas para producción
│   └── modules/
│       ├── secrets-manager/   # Módulo reutilizable para secretos en AWS Secrets Manager
│       └── iam-role/          # Módulo IAM para permisos y perfil de instancia
├── docker-compose.yml         # Composición de servicios: Prometheus + Grafana + Node Exporter
└── README.md                  # Este documento

Cómo Ejecutar el Proyecto
🧪 Opción 1: Ejecutar manualmente con Terraform
bash
Copiar
Editar
cd terraform

# Inicializar el proyecto
terraform init

# Revisar el plan de despliegue
terraform plan -var-file="envs/staging.tfvars"

# Aplicar el plan de infraestructura
terraform apply -auto-approve -var-file="envs/staging.tfvars"
Luego accede a la IP pública de la instancia EC2:

Prometheus: http://<IP>:9090

Grafana: http://<IP>:3000

Las credenciales de Grafana pueden ser recuperadas desde Secrets Manager (si se configuraron).

🚀 Opción 2: Automatización vía GitHub Actions
Asegúrate de tener los secretos configurados en tu repositorio:

AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY

GOOGLE_CHAT_WEBHOOK_URL (opcional)

Realiza un push a la rama master.
Esto desencadenará automáticamente un pipeline que:

Valida y formatea tu código Terraform

Escanea configuración insegura (Checkov)

Detecta secretos (Gitleaks)

Despliega automáticamente la infraestructura

Notifica el resultado en Google Chat