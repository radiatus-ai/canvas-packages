# todo: generate w/ cli
variable "name" {
  type = string
}

variable "region" {
  type = string
}


variable "gcp_authentication" {
  type = any
}

variable "database_version" {
  type = string
}

variable "tier" {
  type = string
}

variable "storage_type" {
  type = string
}

variable "storage_size_gb" {
  type = number
}

variable "availability_type" {
  type = string
}

variable "backup_enabled" {
  type = bool
}
