output "cluster" {
  value = {
    id       = google_container_cluster.main.id
    endpoint = google_container_cluster.main.endpoint
  }
}
