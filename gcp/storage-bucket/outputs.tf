output "bucket" {
  value = {
    id        = module.rad_state_bucket.id
    url       = module.rad_state_bucket.url
    self_link = module.rad_state_bucket.self_link
  }
}
