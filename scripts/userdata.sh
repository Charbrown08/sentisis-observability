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

# Grafana provisioning: datasource
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

# Grafana provisioning: dashboard loader
mkdir -p provisioning/dashboards
cat > provisioning/dashboards/dashboard.yml <<EOL
apiVersion: 1

providers:
  - name: 'default'
    folder: ''
    type: file
    options:
      path: /etc/grafana/provisioning/dashboards
EOL

# Grafana dashboard JSON: CPU + RAM
cat > provisioning/dashboards/node-dashboard.json <<EOL
{
  "annotations": { "list": [ { "builtIn": 1, "type": "dashboard" } ] },
  "editable": true,
  "id": null,
  "iteration": 1623340800111,
  "panels": [
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": { "unit": "percent" },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 12, "x": 0, "y": 0 },
      "id": 1,
      "options": {
        "reduceOptions": { "calcs": ["avg"], "fields": "", "values": false },
        "orientation": "horizontal",
        "showThresholdLabels": false,
        "showThresholdMarkers": true
      },
      "targets": [
        {
          "expr": "100 - (avg by (instance) (irate(node_cpu_seconds_total{mode='idle'}[5m])) * 100)",
          "legendFormat": "CPU Usage",
          "refId": "A"
        }
      ],
      "title": "CPU Usage (%)",
      "type": "gauge"
    },
    {
      "datasource": "Prometheus",
      "fieldConfig": {
        "defaults": { "unit": "bytes" },
        "overrides": []
      },
      "gridPos": { "h": 8, "w": 12, "x": 12, "y": 0 },
      "id": 2,
      "options": {
        "reduceOptions": { "calcs": ["lastNotNull"], "fields": "", "values": false }
      },
      "targets": [
        {
          "expr": "node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes",
          "legendFormat": "RAM Usage",
          "refId": "A"
        }
      ],
      "title": "RAM Usage",
      "type": "stat"
    }
  ],
  "schemaVersion": 30,
  "title": "EC2 System Metrics",
  "version": 1
}
EOL

# Docker Compose file for Prometheus, Grafana, node_exporter
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

# Launch all containers
docker-compose up -d
