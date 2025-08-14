variable "environment" {
  description = "POC environment"
  type        = string
  default     = "poc" # optional default value
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "s3_website" {
  type    = string
  default = "windevopscloud-s3-website"
}