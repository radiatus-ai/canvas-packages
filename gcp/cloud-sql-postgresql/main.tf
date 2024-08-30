resource "google_sql_database_instance" "main" {
  name             = var.name
  region           = var.region
  database_version = var.database_version
  settings {
    # Second-generation instance tiers are based on the machine
    # type. See argument reference below.
    # https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance
    tier              = var.tier
    disk_type         = var.storage_type
    disk_size         = var.storage_size_gb
    availability_type = var.availability_type
    backup_configuration {
      enabled            = var.backup_enabled
      binary_log_enabled = true
    }
  }

  deletion_protection = "true"
}
