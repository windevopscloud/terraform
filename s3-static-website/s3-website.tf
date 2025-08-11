#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "static_website" {
  bucket = "windevopscloud-s3-website"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = aws_kms_key.s3_key.arn
      }
    }
  }

  tags = {
    Name        = "Static Website"
    Environment = var.environment
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "AllowPublicRead"
      Effect    = "Allow"
      Principal = "*"
      Action    = ["s3:GetObject"]
      Resource  = ["${aws_s3_bucket.static_website.arn}/*"]
    }]
  })
}

resource "aws_s3_bucket_object" "website_files" {
  for_each = fileset("s3-website", "**")

  bucket = aws_s3_bucket.static_website.bucket
  key    = each.value
  source = "s3-website/${each.value}"
}