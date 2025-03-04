variable "environment" {
  description = "Nom de l'environnement (dev, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block pour le VPC"
  type        = string
}

variable "public_subnets_cidrs" {
  description = "Liste des CIDR pour les subnets publics"
  type        = list(string)
}

variable "private_subnets_cidrs" {
  description = "Liste des CIDR pour les subnets privés"
  type        = list(string)
}

variable "availability_zones" {
  description = "Liste des zones de disponibilité où créer les subnets"
  type        = list(string)
}


variable "instance_type" {
  description = "Type d'instance pour l'instance NAT gratuite"
  type        = string
  default     = "t2.micro"
}

# Configuration dynamique des Security Groups
variable "security_groups" {
  description = "Définition des Security Groups dynamiques"
  type = map(object({
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}
