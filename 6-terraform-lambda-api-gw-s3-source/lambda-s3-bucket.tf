# 1 bucket creation

resource "aws_s3_bucket" "lf-tf-1-bucket" {
  bucket = "lf-tf-1-bucket"
  force_destroy = true
}

# 2 Block all public access to bucket

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.lf-tf-1-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}