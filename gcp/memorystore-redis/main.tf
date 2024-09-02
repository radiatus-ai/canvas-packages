resource "google_compute_global_address" "service_range" {
  name          = "address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.network.id
}

resource "google_service_networking_connection" "private_service_connection" {
  network                 = var.network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.service_range.name]
}


resource "google_redis_instance" "main" {
  name               = var.name
  authorized_network = google_service_networking_connection.private_service_connection.network

  memory_size_gb = var.memory_size_gb
  tier           = var.tier
  region         = var.region
  redis_version  = var.redis_version
  labels         = var.labels

  lifecycle {
    prevent_destroy = false
  }
  depends_on = [google_project_service.apis]
}


# i want to move this to a central location to manage in the deployment pipeline.
# pre-deploy checklist perhaps.
locals {
  apis = ["memcache.googleapis.com"]
}

resource "google_project_service" "apis" {
  for_each = toset(local.apis)
  project  = var.gcp_authentication.project_id
  service  = each.value

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy = false
}
