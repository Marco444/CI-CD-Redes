output "bucket" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table" {
  value = aws_dynamodb_table.terraform_locks.name
}


output "repository_url" {
  value = aws_ecr_repository.lendaread_ecr.repository_url
}
