output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "argocd_server_url" {
  value = helm_release.argocd.status["url"]
  description = "ArgoCD server URL (if available)"
} 