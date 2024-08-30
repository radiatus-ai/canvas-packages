module "auto_cluster_0" {
  # todo: tags can technically be moved around, so we can't trust this. Probably will have to fork the repo.
  source     = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/gke-cluster-autopilot?ref=v29.0.0"
  project_id = module.project.id
  name       = var.name
  location   = var.region
  vpc_config = {
    # network    = module.vpc.self_link
    # subnetwork = module.vpc.subnets["us-central1/gkeauto-0-us-central1"].self_link
    network    = "foo"
    subnetwork = "bar"
    secondary_range_names = {
      pods     = "pods"
      services = "services"
    }
    # when we switch to a private cluster
    # master_authorized_ranges = {
    #   internal-vms = "10.0.0.0/8"
    # }
    master_ipv4_cidr_block = "10.300.0.0/28"
    # when we switch to a private cluster
    # master_ipv4_cidr_block = "192.168.0.0/28"
  }
  # when we switch to a private cluster
  # private_cluster_config = {
  #   enable_private_endpoint = true
  #   master_global_access    = false
  # }
  labels = {
    environment = "dev"
  }
  # node_config = {
  #   service_account = google_service_account.node_sa.email
  # }
  enable_features = {
    cost_management = true
    # groups_for_rbac = gke-security-group@....
  }
  enable_addons = {
    cloudrun         = false
    config_connector = false
  }
  logging_config = {
    enable_api_server_logs         = false
    enable_scheduler_logs          = true
    enable_controller_manager_logs = false
  }
  deletion_protection = false
}
