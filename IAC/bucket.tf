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
  bucket   = aws_s3_bucket.static_website.id
  for_each = fileset("${local.website_source_path}", "**")
  key      = each.value
  source   = "${local.website_source_path}${each.value}"
  etag     = filemd5("${local.website_source_path}${each.value}")
}
