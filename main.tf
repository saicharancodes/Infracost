# Configure the Google Cloud provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Define variables
variable "project_id" {
  type = string
  description = "The GCP project ID"
}

variable "environment" {
  type = string
  description = "The environment (e.g., dev, prod)"
}

variable "location" {
  type = string
  default = "europe-west1"
  description = "The location for the bucket"
}

variable "storage_class" {
  type = string
  default = "STANDARD"
  description = "The storage class for the bucket"
}

variable "read_write_access" {
  type = list(string)
  description = "List of service accounts with read/write access"
}

variable "read_only_access" {
  type = list(string)
  description = "List of service accounts with read-only access"
  default = []
}

# Construct bucket name
locals {
  bucket_name = "out-dlm-is-${var.environment}"
}

# Create a Google Cloud Storage bucket
resource "google_storage_bucket" "bucket" {
  name          = local.bucket_name
  project       = var.project_id
  location      = var.location
  storage_class = var.storage_class
  force_destroy = true

  labels = {
    data-classification = "is"
    pii_included      = "no"
    crop_number       = "NA"
    bucket_type       = "data"
  }

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age              = 7
      storage_class    = ["NEARLINE"]

    }
    action {
      type = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }


   lifecycle_rule {
    condition {
      age              = 30
    }
    action {
      type = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }


}

# Grant read/write access to the bucket
resource "google_storage_bucket_iam_member" "read_write" {
  for_each = toset(var.read_write_access)
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${each.value}"
}

# Grant read-only access to the bucket
resource "google_storage_bucket_iam_member" "read_only" {
  for_each = toset(var.read_only_access)
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${each.value}"
}