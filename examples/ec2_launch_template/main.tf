terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

provider "aws" { region = var.region }

resource "aws_launch_template" "this" {
  name          = var.lt_name
  image_id      = var.ami_id
  instance_type = var.instance_type

  # Security defaults: IMDSv2 required, no public IP by default
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  network_interfaces {
    associate_public_ip_address = false
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      encrypted  = true
      # If kms_key_id is "", set null so Terraform omits it.
      kms_key_id = var.kms_key_id != "" ? var.kms_key_id : null
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = var.lt_name })
  }
}
