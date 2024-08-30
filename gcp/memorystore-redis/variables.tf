# todo: generate w/ cli
variable "name" {
  type = string
}

variable "gcp_authentication" {
  type = any
}

variable "region" {
  type        = string
  description = "The region where the Redis instance will be located"
}

variable "tier" {
  type        = string
  description = "The service tier of the instance"
  default     = "STANDARD_HA"
}

variable "memory_size_gb" {
  type        = number
  description = "Redis memory size in GiB"
}

variable "redis_version" {
  type        = string
  description = "The version of Redis software"
  default     = "REDIS_6_X"
}

variable "labels" {
  type        = map(string)
  description = "A set of key/value label pairs to assign to the instance"
  default     = {}
}
