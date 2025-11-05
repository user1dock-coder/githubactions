terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.64"
    }
  }
}

variable "region" {
  description = "AWS region to deploy the bootstrap resources"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform remote state"
  type        = string
}

variable "dynamodb_table" {
  description = "Name of the DynamoDB table for Terraform state lock"
  type        = string
}

provider "aws" {
  region = var.region
  profile = "clirishitha"
}

resource "aws_s3_bucket" "tf_state" {
  bucket        = var.bucket_name
  force_destroy = false

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "bootstrap"
    ManagedBy   = "Terraform"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "v" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "pab" {
  bucket                  = aws_s3_bucket.tf_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = var.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "Terraform Lock Table"
    Environment = "bootstrap"
    ManagedBy   = "Terraform"
  }
}

output "s3_bucket_name" {
  description = "S3 bucket used for Terraform remote state"
  value       = aws_s3_bucket.tf_state.bucket
}

output "dynamodb_table_name" {
  description = "DynamoDB table used for Terraform state locking"
  value       = aws_dynamodb_table.tf_lock.name
}
