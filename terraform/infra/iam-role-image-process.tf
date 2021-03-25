data "aws_iam_policy_document" "lambda_process_assume_policy" {

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_process_policies" {

  statement {
    actions = ["s3:PutObject", "s3:GetObject"]

    resources = [ aws_s3_bucket.images_bucket.arn, "${aws_s3_bucket.images_bucket.arn}/*" ]
  }

    statement {
    actions = ["logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"]

    resources = [ "*" ]
  }
}

resource "aws_iam_role" "process_role" {
  name               = "${var.env}-lambda-process-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.lambda_process_assume_policy.json
  inline_policy {
    name   = "process-policy"
    policy = data.aws_iam_policy_document.lambda_process_policies.json
  }

}

resource "aws_ssm_parameter" "process_iam_role" {
  name  = "${var.env}-process-role"
  value = aws_iam_role.process_role.arn
  type  = "String"
}