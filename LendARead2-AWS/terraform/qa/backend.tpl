terraform {
  backend "s3" {
    bucket         = "${bucket}"
    key            = "qa/terraform.tfstate"
    region         = "${region}"
    encrypt        = true
    dynamodb_table = "${dynamodb_table}"
  }
}
