# Day 1 — AI-Drafted Terraform (S3)

Goal: Use a structured prompt to generate secure S3 Terraform.

## Prompt
See prompts/terraform_s3.txt.

## Usage (local)
cp terraform.tfvars.example terraform.tfvars
# edit values inside terraform.tfvars

terraform init
terraform validate
# terraform plan   # requires AWS credentials

## Files
- variables.tf, main.tf, outputs.tf
- terraform.tfvars.example
- prompts/terraform_s3.txt
- .github/workflows/tf-validate.yml
