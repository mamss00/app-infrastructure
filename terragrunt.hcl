terraform {
  source = "./modules//${path_relative_to_include()}"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "ms-app-terraform-state-bucket"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "ms-app-terraform-locks"
    encrypt        = true
  }
}
