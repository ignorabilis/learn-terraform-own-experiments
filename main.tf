# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      hashicorp-learn = "resource-targeting"
    }
  }
}

resource "random_pet" "bucket_name" {
  length    = 5
  separator = "-"
  prefix    = "learning"
}

resource "random_pet" "bucket_names" {
  count     = 3
  length    = 5
  separator = "-"
  prefix    = "learning"
}

locals {
  #random_names = [random_pet.bucket_name[count.index].id for count in range(3)]
  all_bucket_names = concat([random_pet.bucket_name.id], random_pet.bucket_names.*.id)
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.10.1"

  count = 4

  bucket = local.all_bucket_names[count.index]
  # bucket = random_pet.bucket_name.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# ACL & Policies are no longer working out of the box;
# that's a temporary fix so that things at least run.
# tried applying this in another project but it didn't work -
# it still showed permission issues; tried now using -target
# and doing it step by step and it worked...
# it worked because it needs some time to reflect the changes

resource "aws_s3_bucket_ownership_controls" "buckets" {
  count  = 4
  bucket = local.all_bucket_names[count.index]

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "time_sleep" "delay" {
  depends_on      = [aws_s3_bucket_ownership_controls.buckets]
  create_duration = "10s"
}

# delaying works... ¯\_(ツ)_/¯
resource "aws_s3_bucket_acl" "buckets" {
  count  = 4
  bucket = local.all_bucket_names[count.index]

  acl = "private"
}

resource "random_pet" "object_names" {
  count = 16

  length    = 5
  separator = "_"
  prefix    = "learning"
}

resource "aws_s3_object" "objects" {
  count = 16

  acl          = "public-read"
  key          = "${random_pet.object_names[count.index].id}.txt"
  bucket       = module.s3_bucket[count.index % 4].s3_bucket_id
  content      = "Example object #${count.index}"
  content_type = "text/plain"
}

moved {
  from = module.s3_bucket
  to   = module.s3_bucket[0]
}
