# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.1"
    }
  }

  required_version = "~> 1.4.0"

  cloud {
    organization = "ignorabilis"
    workspaces {
      name = "learn-terraform-resource-targeting"
    }
  }
}

