# Configure the Google Cloud provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

# Set the project ID
variable "project_id" {
  type = string
  description = "The ID of the Google Cloud project"
}

# Set the environment
variable "environment" {
  type = string
  description = "The environment (e.g., dev, prod)"
}

# Define the bucket name
variable "bucket_name" {
  type = string
  description = "The name of the GCS bucket"
  default = "out-dlm-is"
}

# Define the location
variable "location" {
  type = string
  description = "The location of the GCS bucket"
  default = "europe-west1"
}

# Define the storage class
variable "storage_class" {
  type = string
  description = "The storage class of the GCS bucket"
  default = "STANDARD"
}

# Define the lifecycle rules
variable "lifecycle_rules" {
  type = list(object({
    age          = number
    storage_class = string
  }))
  default = [
    {
      age          = 7
      storage_class = "NEARLINE"
    },
    {
      age          = 30
      storage_class = "COLDLINE"
    },
    {
      age          = 90
      storage_class = "DELETE"
    }
  ]
}

# Define the labels
variable "labels" {
  type = map(string)
  description = "The labels to apply to the GCS bucket"
  default = {
    data-classification = "is"
    pii_included        = "no"
    crop_number         = "NA"
    bucket_type         = "data"
    data_container_name = "<Specify the container name where the data is stored>"
  }
}

# Create the GCS bucket
resource "google_storage_bucket" "bucket" {
  name                        = "${var.bucket_name}-${var.environment}"
  project                     = var.project_id
  location                    = var.location
  storage_class               = var.storage_class
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = var.lifecycle_rules[0].age
    }
    action {
      type          = "SetStorageClass"
      storage_class = var.lifecycle_rules[0].storage_class
    }
  }
  lifecycle_rule {
    condition {
      age = var.lifecycle_rules[1].age
    }
    action {
      type          = "SetStorageClass"
      storage_class = var.lifecycle_rules[1].storage_class
    }
  }
   lifecycle_rule {
    condition {
      age = var.lifecycle_rules[2].age
    }
    action {
      type = "Delete"
    }
  }

  labels = merge(var.labels, {
    environment = var.environment
  })
}

# Grant Read/Write access to tf-<env>.iam.gserviceaccount.com
resource "google_storage_bucket_iam_member" "read_write_tf" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:tf-${var.environment}.iam.gserviceaccount.com"
}

# Grant Read/Write access to ftp-<env>.iam.gserviceaccount.com
resource "google_storage_bucket_iam_member" "read_write_ftp" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:ftp-${var.environment}.iam.gserviceaccount.com"
}

# Grant Read Only access to <please specify which service account should have Read Only access, please highlight if it's another project Service Account>
# Example:
# resource "google_storage_bucket_iam_member" "read_only" {
#   bucket = google_storage_bucket.bucket.name
#   role   = "roles/storage.objectViewer"
#   member = "serviceAccount:your-service-account@your-project.iam.gserviceaccount.com"
# }