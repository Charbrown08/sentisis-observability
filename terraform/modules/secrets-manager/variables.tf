variable "grafana_secret_name" {
  description = "Name of the Grafana secret"
  type        = string
  default     = "grafana/admin"
}

variable "grafana_username" {
  description = "Grafana admin username"
  type        = string
  default     = "admin"
}

variable "grafana_password" {
  description = "Grafana admin password"
  type        = string
  default     = "supersegura123"
}
