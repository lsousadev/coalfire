module "bucket_images" {
  source = "github.com/lsousadev/terraform-aws-s3?ref=df530eb61738834c273bbef9a74b4a25a521ea13"

  name          = "${var.resource_prefix}-images"
  versioning    = false
  force_destroy = true

  lifecycle_configuration_rules = [
    {
      "enabled" : true,
      "id" : "memes_glacier_rule",
      "prefix" : "Memes/"
      "enable_glacier_transition" : true,
      "glacier_transition_days" : 90,

      "enable_current_object_expiration" : false,
      "enable_noncurrent_version_expiration" : false
    }
  ]
}

resource "aws_s3_object" "archive_dir" {
  bucket = module.bucket_images.id
  key    = "Archive/"
}

resource "aws_s3_object" "memes_dir" {
  bucket = module.bucket_images.id
  key    = "Memes/"
}

module "bucket_logs" {
  source = "github.com/lsousadev/terraform-aws-s3"

  name                          = "${var.resource_prefix}-logs"
  attach_lb_log_delivery_policy = true
  bucket_policy                 = true
  aws_iam_policy_document       = templatefile("s3_logs_bucket_policy.tpl", { bucket_arn = module.bucket_logs.arn }) # allow ALB to write to bucket
  versioning                    = false
  enable_kms                    = false # ALB can't write to bucket with S3-KMS, only S3-SSE
  force_destroy                 = true

  lifecycle_configuration_rules = [
    {
      "enabled" : true,
      "id" : "active_glacier_rule",
      "prefix" : "Active/",
      "enable_glacier_transition" : true,
      "glacier_transition_days" : 90,

      "enable_current_object_expiration" : false,
      "enable_noncurrent_version_expiration" : false
    },
    {
      "enabled" : true,
      "id" : "inactive_delete_rule",
      "prefix" : "Inactive/",
      "enable_current_object_expiration" : true,
      "expiration_days" : 90,

      "enable_glacier_transition" : false,
      "enable_noncurrent_version_expiration" : false
    }
  ]
}

resource "aws_s3_object" "active_dir" {
  bucket = module.bucket_logs.id
  key    = "Active/"
}

resource "aws_s3_object" "inactive_dir" {
  bucket = module.bucket_logs.id
  key    = "Inactive/"
}
