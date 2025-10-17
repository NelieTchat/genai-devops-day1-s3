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

## CI Status
[![Terraform Validate](https://github.com/NelieTchat/genai-devops-day1-s3/actions/workflows/tf-validate.yml/badge.svg)](https://github.com/NelieTchat/genai-devops-day1-s3/actions/workflows/tf-validate.yml)

## CI Status
[![Terraform Validate](https://github.com/NelieTchat/genai-devops-day1-s3/actions/workflows/tf-validate.yml/badge.svg)](https://github.com/NelieTchat/genai-devops-day1-s3/actions/workflows/tf-validate.yml)
[![tflint](https://github.com/NelieTchat/genai-devops-day1-s3/actions/workflows/tflint.yml/badge.svg)](https://github.com/NelieTchat/genai-devops-day1-s3/actions/workflows/tflint.yml)
[![checkov](https://github.com/NelieTchat/genai-devops-day1-s3/actions/workflows/checkov.yml/badge.svg)](https://github.com/NelieTchat/genai-devops-day1-s3/actions/workflows/checkov.yml)

[![GenAI Codegen](https://github.com/NelieTchat/genai-devops-day1-s3/actions/workflows/genai-codegen.yml/badge.svg)](https://github.com/NelieTchat/genai-devops-day1-s3/actions/workflows/genai-codegen.yml)
