resource "google_memcache_instance" "main" {
  name = var.name
  # authorized_network = var.network

  node_config {
    cpu_count      = var.node_cpu
    memory_size_mb = var.node_memory_mb
  }

  node_count = var.node_count
  region     = var.region

  memcache_version = var.memcache_version
  labels           = var.labels
}
