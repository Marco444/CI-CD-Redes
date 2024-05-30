terraform {
  backend "s3" {
    bucket         = "${bucket}"
    key            = "terraform/state"
    region         = "${region}"
    encrypt        = true
    dynamodb_table = "${dynamodb_table}"
  }
}
