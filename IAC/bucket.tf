resource "aws_s3_bucket" "static_website" {
  bucket = local.domain_name
  tags = {
    terraform   = "True"
    name        = "website"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_ownership_controls" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static_website" {
  depends_on = [aws_s3_bucket_ownership_controls.static_website]

  bucket = aws_s3_bucket.static_website.id
  acl    = "private"
}

resource "aws_s3_object" "static_website" {
  bucket = aws_s3_bucket.static_website.id
  for_each = fileset("../Personal-website/","*")
  key = each.value
  source = "../Personal-website/${each.value}"
  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("../Personal-website/${each.value}")
}
