resource "google_compute_global_address" "service_range" {
  name          = "${var.name}-service-range"
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

resource "google_memcache_instance" "main" {
  name               = var.name
  authorized_network = "projects/rad-dev-dogfood-n437/global/networks/nexxxttt"

  node_config {
    cpu_count      = var.node_cpu
    memory_size_mb = var.node_memory_mb
  }

  node_count = var.node_count
  region     = var.region

  memcache_version = var.memcache_version
  labels           = var.labels
  depends_on       = [google_project_service.apis]
}


# i want to move this to a central location to manage in the deployment pipeline.
# pre-deploy checklist perhaps.
locals {
  apis = ["memcache.googleapis.com",
    # we might need this just to load the ui in gcp. we don't need this to provision the memcache instance.
    "redis.googleapis.com"
  ]
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
