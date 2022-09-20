provider "aws" {
  shared_config_files      = ["C:/Users/ygorp/.aws/config"]
  shared_credentials_files = ["C:/Users/ygorp/.aws/credentials"]
  profile                  = "default"
}

resource "aws_sqs_queue" "terraform_queue_deadletter" {
  name = "terraform-example-deadletter-queue"
  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue",
    sourceQueueArns   = ["arn:aws:sqs:sa-east-1:604065395547:pessoa-queue"]
  })
}

resource "aws_sqs_queue" "pessoa-queue" {
  name                      = "pessoa-queue"
  delay_seconds             = 1
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = "arn:aws:sqs:sa-east-1:604065395547:terraform-example-deadletter-queue"
    maxReceiveCount     = 4
  })

  tags = {
    Environment = "development"
  }
}