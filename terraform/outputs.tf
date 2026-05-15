output "vpc_id" {
  description = "Created VPC ID."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = module.networking.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.networking.private_subnet_ids
}

output "ecr_repository_url" {
  description = "ECR repository URL for application images."
  value       = aws_ecr_repository.app.repository_url
}
