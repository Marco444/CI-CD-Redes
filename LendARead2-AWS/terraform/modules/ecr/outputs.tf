output "repository_url" {
  value       = aws_ecr_repository.lendaread_ecr.repository_url
  description = "ECR repository URL"
}

output "docker_image" {
  value       = null_resource.docker_image.id
  description = "resource to trigger new re-deployment"
}

