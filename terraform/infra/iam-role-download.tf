data "aws_iam_policy_document" "lambda_download_assume_policy" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_download_policies" {

  statement {
    actions = ["s3:ListBucket", "s3:GetObject"]

    resources = [ aws_s3_bucket.images_bucket.arn, "${aws_s3_bucket.images_bucket.arn}/*" ]
  }

  statement {
    actions = ["logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"]

    resources = [ "*" ]
  }
}

resource "aws_iam_role" "download_role" {
  name               = "${var.env}-lambda-download-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.lambda_download_assume_policy.json
  inline_policy {
    name   = "download-policy"
    policy = data.aws_iam_policy_document.lambda_download_policies.json
  }

}

resource "aws_ssm_parameter" "download_iam_role" {
  name  = "${var.env}-download-role"
  value = aws_iam_role.download_role.arn
  type  = "String"
}