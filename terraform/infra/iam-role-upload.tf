data "aws_iam_policy_document" "lambda_upload_assume_policy" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_upload_policies" {

  statement {
    actions = ["s3:PutObject"]

    resources = [ aws_s3_bucket.images_bucket.arn, "${aws_s3_bucket.images_bucket.arn}/*" ]
  }

    statement {
    actions = ["logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"]

    resources = [ "*" ]
  }
}

resource "aws_iam_role" "upload_role" {
  name               = "${var.env}-lambda-upload-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.lambda_upload_assume_policy.json
  inline_policy {
    name   = "upload-policy"
    policy = data.aws_iam_policy_document.lambda_upload_policies.json
  }

}

resource "aws_ssm_parameter" "upload_iam_role" {
  name  = "${var.env}-upload-role"
  value = aws_iam_role.upload_role.arn
  type  = "String"
}