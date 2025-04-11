resource "aws_secretsmanager_secret" "grafana" {
  name = var.grafana_secret_name
}

resource "aws_secretsmanager_secret_version" "grafana" {
  secret_id     = aws_secretsmanager_secret.grafana.id
  secret_string = jsonencode({
    username = var.grafana_username
    password = var.grafana_password
  })
}
