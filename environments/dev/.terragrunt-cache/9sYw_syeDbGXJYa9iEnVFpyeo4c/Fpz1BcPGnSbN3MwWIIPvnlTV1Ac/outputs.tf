output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id  # 🔹 Retourne une liste des IDs des subnets publics
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id  # 🔹 Retourne une liste des IDs des subnets privés
}


output "nat_instance_id" {
  value = aws_instance.nat_instance.id
}
