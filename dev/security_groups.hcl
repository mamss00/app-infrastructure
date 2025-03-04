locals {
  base_config = yamldecode(file("${get_terragrunt_dir()}/../common/config/base_security_groups.yaml"))
  env_config  = yamldecode(file("${get_terragrunt_dir()}/config/security_groups.yaml"))

  # Fusionner la configuration globale avec celle de l’environnement
  security_groups = merge(local.base_config, local.env_config)
}

inputs = {
  security_groups = local.security_groups
}
