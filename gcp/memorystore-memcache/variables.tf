# todo: generate w/ cli
variable "name" {
  type = string
}

variable "gcp_authentication" {
  type = any
}

variable "labels" {
  type        = map(string)
  description = "A set of key/value label pairs to assign to the instance"
  default     = {}
}

variable "region" {
  type        = string
  description = "The region where the Redis instance will be located"
}

variable "node_count" {
  type        = number
  description = "The number of nodes in the Memcached instance"
  default     = 1
}

variable "node_cpu" {
  type        = number
  description = "The number of CPUs per node"
  default     = 1
}

variable "node_memory_mb" {
  type        = number
  description = "The amount of memory per node in MB"
  default     = 1024
}

variable "memcache_version" {
  type        = string
  description = "The version of Memcached software"
  default     = "MEMCACHE_1_5"
}

variable "memcache_parameters" {
  type        = any
  description = "Additional Memcached parameters"
  default     = {}
}

variable "network" {
  type    = any
  default = {}
}
