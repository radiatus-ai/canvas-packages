output "instance" {
  value = {
    id                 = google_memcache_instance.main.id
    discovery_endpoint = google_memcache_instance.main.discovery_endpoint
  }
}
