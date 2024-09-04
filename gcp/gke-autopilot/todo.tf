# terraform {
#   required_providers {
#     kubernetes = {
#       source  = "hashicorp/kubernetes"
#       version = "~> 2.20.0"
#     }
#     helm = {
#       source  = "hashicorp/helm"
#       version = "~> 2.9.0"
#     }
#   }
# }

# provider "kubernetes" {
#   config_path = "~/.kube/config" # Path to your kubeconfig file
# }

# provider "helm" {
#   kubernetes {
#     config_path = "~/.kube/config" # Path to your kubeconfig file
#   }
# }

# # external secret manaer
# resource "helm_release" "rad_app" {
#   name       = "rad-app"
#   repository = "https://charts.bitnami.com/bitnami" # Example repository
#   chart      = "nginx"                              # Example chart
#   namespace  = "default"

#   set {
#     name  = "replicaCount"
#     value = "2"
#   }

#   set {
#     name  = "service.type"
#     value = "LoadBalancer"
#   }
# }








# use this to deploy external secrets manager
