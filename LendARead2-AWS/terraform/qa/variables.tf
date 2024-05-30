variable "role" {
  type = string
}

variable "rds_password" {
  type = string
}

variable "multi_az_rds" {
  description = "Boolean to determine RDS replication"
  type        = bool
}


variable "ecr_repository_url" {
  description = "URL of ECR repository"
  type        = string
}
