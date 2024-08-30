resource "google_redis_instance" "main" {
  name           = var.name
  memory_size_gb = var.memory_size_gb
  tier           = var.tier
  region         = var.region
  redis_version  = var.redis_version
  labels         = var.labels

  lifecycle {
    prevent_destroy = false
  }
}
