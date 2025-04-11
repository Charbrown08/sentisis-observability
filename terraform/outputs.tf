output "ec2_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.observability_ec2.public_ip
}

output "grafana_url" {
  description = "URL to access Grafana in the browser"
  value       = "http://${aws_instance.observability_ec2.public_ip}:3000"
}

output "prometheus_url" {
  description = "URL to access Prometheus in the browser"
  value       = "http://${aws_instance.observability_ec2.public_ip}:9090"
}
