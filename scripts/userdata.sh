#!/bin/bash

# Update and install Docker
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Create working directory
mkdir -p /opt/observability
cd /opt/observability

# Prometheus configuration
cat > prometheus.yml <<EOL
global:
  scrape_interval: 10s

scrape_configs:
  - job_name: 'node'
    static_configs:
      - targets: ['node_exporter:9100']
EOL

# Grafana provisioning for Prometheus as data source
mkdir -p provisioning/datasources
cat > provisioning/datasources/datasource.yml <<EOL
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
EOL

# Docker Compose file including node_exporter
cat > docker-compose.yml <<EOL
version: '3'

services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - ./provisioning:/etc/grafana/provisioning

  node_exporter:
    image: prom/node-exporter:latest
    ports:
      - "9100:9100"
EOL

# Launch all services
docker-compose up -d
