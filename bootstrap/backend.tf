terraform {
  backend "s3" {
    bucket         = "ms-app-terraform-state-bucket"
    key            = "global/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "ms-app-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-central-1"
}
