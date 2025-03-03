#!/bin/bash

# Variables AWS
AWS_REGION="eu-central-1"
BUCKET_NAME="ms-app-terraform-state-bucket"
DYNAMODB_TABLE="ms-app-terraform-locks"

# Vérifier si AWS CLI est installé
if ! command -v aws &> /dev/null
then
    echo "AWS CLI n'est pas installé. Veuillez l'installer avant de continuer."
    exit 1
fi

# Créer le bucket S3 si non existant
if ! aws s3 ls "s3://$BUCKET_NAME" 2>/dev/null; then
    echo "Création du bucket S3: $BUCKET_NAME"
    aws s3api create-bucket --bucket $BUCKET_NAME --region $AWS_REGION --create-bucket-configuration LocationConstraint=$AWS_REGION
    aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled
else
    echo "Bucket S3 $BUCKET_NAME existe déjà."
fi

# Créer la table DynamoDB pour le verrouillage Terraform
if ! aws dynamodb describe-table --table-name $DYNAMODB_TABLE --region $AWS_REGION 2>/dev/null; then
    echo "Création de la table DynamoDB: $DYNAMODB_TABLE"
    aws dynamodb create-table \
        --table-name $DYNAMODB_TABLE \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --region $AWS_REGION
else
    echo "Table DynamoDB $DYNAMODB_TABLE existe déjà."
fi

echo "✅ Backend Terraform (S3 + DynamoDB) initialisé avec succès."
