# Define the S3 bucket
resource "aws_s3_bucket" "static_website" {
  bucket = "windevopscloud-s3-website"  # Replace with your unique bucket name
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"  # Optional error page
  }

  versioning {
    enabled = true  # Enable versioning
  }

  tags = {
    Name        = "Static Website"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_object" "website_files" {
  for_each = fileset("s3-website", "**")  # 's3-website' is the local directory to upload from

  bucket = aws_s3_bucket.static_website.bucket
  key    = each.value
  source = "website/${each.value}"  # Local path to the file
  acl    = "public-read"
}