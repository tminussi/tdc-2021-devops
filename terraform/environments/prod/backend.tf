terraform {
  backend "s3" {
    bucket = "tdc-2021-devops-state-bucket"
    key    = "prod/terraform.tfstate"
    region = "us-east-1"
  }
}