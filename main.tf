provider "aws" {
  region = "eu-west-1"
}

# Customize with your own S3 bucket and DynamoDB table if you want to use a Remote Backend for State
terraform {
  backend "s3" {
    bucket         = "windevopscloud-terraform-poc-bucket"     # Update it 
    key            = "windevopscloud-terraform-poc.tfstate" # Update it
    region         = "us-east-1"                            # Update it
    dynamodb_table = "windevopscloud-terraform-poc-lock"                       # Update it
    encrypt        = true
  }
}

