data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "elb_log_bucket" {
  bucket = var.bucket_name
  policy = <<-EOF
            {
              "Version": "2012-10-17",
              "Statement": [
                {
                  "Effect": "Allow",
                  "Principal": {
                                "AWS": ["${data.aws_elb_service_account.main.arn}"]
                               },
                  "Action": "s3:PutObject",
                  "Resource": "arn:aws:s3:::${var.bucket_name}/*"
                }
              ]
            }
            EOF
}