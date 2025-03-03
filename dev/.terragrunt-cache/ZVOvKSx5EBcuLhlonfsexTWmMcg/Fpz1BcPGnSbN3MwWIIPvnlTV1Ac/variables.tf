variable "environment" {
  description = "Nom de l'environnement (dev, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block pour le VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block pour le subnet public"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block pour le subnet privé"
  type        = string
}

variable "availability_zone" {
  description = "Zone de disponibilité AWS"
  type        = string
}

variable "instance_type" {
  description = "Type d'instance pour l'instance NAT gratuite"
  type        = string
  default     = "t2.micro"
}

variable "allowed_ingress_ports" {
  description = "Liste des ports autorisés pour l'accès entrant"
  type        = list(number)
  default     = [80, 443, 22]
}
