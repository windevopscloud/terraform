resource "aws_s3_bucket" "static_website" {
  bucket = "windevopscloud-s3-website"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  versioning {
    enabled = true
  }

  tags = {
    Name        = "Static Website"
    Environment = "var.environment"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.static_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.static_website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
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
  acl    = "public-read"
}