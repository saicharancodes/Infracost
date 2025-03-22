# Configure the Google Cloud provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Replace with your project ID
variable "project_id" {
  type = string
  default = "your-project-id"
}

# Environment variable
variable "environment" {
  type = string
  default = "dev"
}

# GCS Bucket Name
variable "bucket_name" {
  type = string
  default = "out-dlm-is"
}

# Location for the GCS Bucket
variable "location" {
  type = string
  default = "europe-west1"
}

# Service account for read/write access
variable "read_write_service_accounts" {
  type = list(string)
  default = [
    "tf-${var.environment}.iam.gserviceaccount.com",
    "ftp-${var.environment}.iam.gserviceaccount.com"
  ]
}

# Service account for read-only access
variable "read_only_service_accounts" {
  type = list(string)
  default = []
}

# GCS Bucket Resource
resource "google_storage_bucket" "bucket" {
  name                        = "${var.bucket_name}-${var.environment}"
  project                     = var.project_id
  location                    = var.location
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    data-classification = "is"
    pii_included        = "no"
    crop_number         = "NA"
    bucket_type         = "data"
    data_container_name = "<>"  # Replace with the actual container name
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
      age          = 7
      storage_class = ["STANDARD"]
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }

    lifecycle_rule {
    condition {
      age          = 30
      storage_class = ["NEARLINE"]
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }
}

# Grant read/write access to the specified service accounts
resource "google_storage_bucket_iam_member" "read_write_access" {
  for_each = toset(var.read_write_service_accounts)
  bucket   = google_storage_bucket.bucket.name
  role     = "roles/storage.objectAdmin"
  member   = "serviceAccount:${each.value}"
}

# Grant read-only access to the specified service accounts
resource "google_storage_bucket_iam_member" "read_only_access" {
  for_each = toset(var.read_only_service_accounts)
  bucket   = google_storage_bucket.bucket.name
  role     = "roles/storage.objectViewer"
  member   = "serviceAccount:${each.value}"
}