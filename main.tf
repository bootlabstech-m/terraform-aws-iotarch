
resource "aws_iot_thing" "main" {
  name = var.name

  attributes = {
    First = var.First
  }
}

resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"
}
# resource "aws_s3_bucket_object" "file_upload" {
#   bucket = aws_s3_bucket.main.id
#   key    = "index.zip"
#   source = "/home/bootlabs/Desktop/iot/iotcoreaws/index.zip"
# }

resource "aws_kinesis_stream" "test_stream" {
  name             = var.kinesis_name
  shard_count      = var.shard_count
  retention_period = var.retention_period

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = var.stream_mode
  }
}

# resource "aws_iam_role" "test_role" {
#   name = "sratest_role"

#   # Terraform's "jsonencode" function converts a
#   # Terraform expression result to valid JSON syntax.
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#         {
            
#             "Action": [
#                 "kinesis:UpdateStreamMode",
#                 "kinesis:ListStreams",
#                 "kinesis:EnableEnhancedMonitoring",
#                 "kinesis:ListShards",
#                 "kinesis:UpdateShardCount",
#                 "kinesis:DescribeLimits",
#                 "kinesis:DisableEnhancedMonitoring"
#             ]
#             Effect = "Allow"
#             Resource = "*"
#         },
#     ]
#   })
# }

resource "aws_lambda_function" "main" {
  s3_bucket     = aws_s3_bucket.main.bucket
  s3_key        = aws_s3_bucket_object.file_upload.key
  function_name = var.function_name
  role          = var.role
  handler       = var.handler
  runtime       = var.runtime
  # environment {
  #   variables = {
  #     BUCKET_NAME = "srabucketmanual"
  #   }
# }
}
resource "aws_lambda_event_source_mapping" "kinesis_lambda_event_mapping" {
    batch_size = 100
    event_source_arn = aws_kinesis_stream.test_stream.arn
    enabled = true
    function_name = "${aws_lambda_function.main.arn}"
    starting_position = "TRIM_HORIZON"
}
