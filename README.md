# app-infrastructure

infra-repo/
│── bootstrap/                 # Scripts pour initialiser AWS
│   ├── backend.tf             # Backend Terraform (S3 + DynamoDB)
│   ├── bootstrap.sh           # Script de création du backend
│── modules/                   # Modules Terraform réutilisables
│   ├── networking/            # VPC, subnets, security groups
│   ├── ecs/                   # Cluster ECS, services, ALB
│   ├── ecr/                   # Docker Registry
│   ├── rds/                   # Base de données (optionnel)
│── dev/                       # Environnement Dev
│   ├── terragrunt.hcl
│── prod/                      # Environnement Prod
│   ├── terragrunt.hcl
│── .github/workflows/          # Pipelines CI/CD Terraform
│── terragrunt.hcl              # Configuration globale
│── README.md                   # Documentation