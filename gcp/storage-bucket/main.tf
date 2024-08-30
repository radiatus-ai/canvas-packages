module "rad_state_bucket" {
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/gcs?ref=v29.0.0"
  project_id = var.gcp_authentication.project_id
  #   prefix     = "rad"
  name                        = var.name
  location                    = var.location
  versioning                  = var.versioning
  labels                      = var.labels
  storage_class               = var.storage_class
  lifecycle_rules             = var.lifecycle_rules
  encryption                  = var.encryption
  uniform_bucket_level_access = var.uniform_bucket_level_access
  public_access_prevention    = var.public_access_prevention
}
