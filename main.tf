
resource "aws_iot_thing" "main" {
  name = var.iot_name

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


resource "aws_lambda_function" "main" {
  s3_bucket     = aws_s3_bucket.main.bucket
  s3_key        = aws_s3_bucket_object.file_upload.key
  function_name = var.function_name
  role          = var.role
  handler       = var.handler
  runtime       = var.runtime 
  environment {
    variables = {
      BUCKET_NAME = "srabucketmanual"
    }


  }
}
resource "aws_lambda_event_source_mapping" "kinesis_lambda_event_mapping" {
    batch_size = 100
    event_source_arn = aws_kinesis_stream.test_stream.arn
    enabled = true
    function_name = "${aws_lambda_function.main.arn}"
    starting_position = "TRIM_HORIZON"
}
