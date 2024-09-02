resource "google_pubsub_topic" "main" {
  name = var.name

  # labels = {
  #   foo = "bar"
  # }

  message_retention_duration = "86600s"

  depends_on = [google_project_service.apis]
}

# i want to move this to a central location to manage in the deployment pipeline.
# pre-deploy checklist perhaps.
locals {
  apis = ["pubsub.googleapis.com"]
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
