/*
 * main.tf - Module Networking
 * Ce fichier définit l'infrastructure réseau incluant :
 * - Un VPC
 * - Des subnets publics et privés (supporte plusieurs subnets)
 * - Une Internet Gateway (IGW)
 * - Une instance NAT pour les subnets privés
 * - Des tables de routage associées
 * - Un module générique pour les Security Groups
 */

terraform {
  backend "s3" {}
}

# Création du VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-${var.environment}"
  }
}

# Création de l'Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-${var.environment}"
  }
}

# Création dynamique des subnets publics
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index + 1}-${var.environment}"
  }
}

# Création dynamique des subnets privés
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "private-subnet-${count.index + 1}-${var.environment}"
  }
}

# Module générique pour les Security Groups
resource "aws_security_group" "sg" {
  for_each = var.security_groups
  vpc_id   = aws_vpc.main.id

  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = "${each.key}-sg-${var.environment}"
  }
}

# Création de l'instance NAT pour les subnets privés
resource "aws_instance" "nat_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_subnets[0].id  # Utilisation du premier subnet public
  associate_public_ip_address = true
  key_name               = "ms"  # Ajout de la clé SSH pour accéder à l'instance
  vpc_security_group_ids = [aws_security_group.sg["nat"].id]

  user_data = file("${path.module}/userdata.sh")

  tags = {
    Name = "nat-instance-${var.environment}"
  }
}

# Table de routage publique
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table-${var.environment}"
  }
}

# Associer tous les subnets publics à la table de routage publique
resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Table de routage privée
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block        = "0.0.0.0/0"
    network_interface_id = aws_instance.nat_instance.primary_network_interface_id
  }

  tags = {
    Name = "private-route-table-${var.environment}"
  }
}

# Associer tous les subnets privés à la table de routage privée
resource "aws_route_table_association" "private_assoc" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

# Récupérer l'AMI Ubuntu la plus récente pour l'instance NAT
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
