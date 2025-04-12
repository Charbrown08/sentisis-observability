output "grafana_secret_arn" {
  description = "ARN of the Grafana secret"
  value       = aws_secretsmanager_secret.grafana1.arn
}
