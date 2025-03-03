terraform {
  source = "../modules/networking"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  environment         = "dev"
  vpc_cidr           = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone  = "eu-central-1a"
  instance_type      = "t2.micro"
  allowed_ingress_ports = [80, 443, 22]
}
