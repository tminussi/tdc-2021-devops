resource "aws_s3_bucket" "images_bucket" {
    bucket_prefix = var.env
    acl    = "private"
    tags = {
        Name        = "TDCBucket"
        Environment = var.env
    }
    force_destroy = true
}

resource "aws_ssm_parameter" "bucket_name" {
  name  = "${var.env}-images-bucket"
  value = aws_s3_bucket.images_bucket.bucket
  type  = "String"
}