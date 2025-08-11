provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

# Customize with your own S3 bucket and DynamoDB table for managing Remote Backend State
terraform {
  backend "s3" {
    bucket         = "windevopscloud-terraform-bucket"  # Update it 
    key            = "windevopscloud-terraform.tfstate" # Update it
    region         = "us-east-1"                        # Update it
    dynamodb_table = "windevopscloud-terraform-lock"    # Update it
    encrypt        = true
  }
}
