terraform {
  source = "${get_repo_root()}/modules/networking"
}

include {
  path = find_in_parent_folders()
}

include "security_groups" {
  path = "${get_terragrunt_dir()}/security_groups.hcl"
}

include "networking" {
  path = "${get_terragrunt_dir()}/networking.hcl"
}

inputs = {
  environment = "dev-infra"
}
