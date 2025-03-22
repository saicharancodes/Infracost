resource "google_storage_bucket" "out_dlm_is" {
  name                        = "out-dlm-is-${var.environment}"
  project                     = "network-tkoff-${var.environment}"
  location                    = "europe-west1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  labels = {
    data-classification = "is"
    pii_included        = "no"
    crop_number         = "NA"
    bucket_type         = "data"
    data_container_name = "<>"
  }

  lifecycle_rule {
    condition {
      age_in_days = 7
      storage_class = "NEARLINE"
    }
    action {
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
    lifecycle_rule {
    condition {
      age_in_days = 30
      storage_class = "COLDLINE"
    }
    action {
      type = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }
    lifecycle_rule {
    condition {
      age_in_days = 90
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket_iam_binding" "read_write_access" {
  bucket = google_storage_bucket.out_dlm_is.name
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:tf-${var.environment}.iam.gserviceaccount.com",
    "serviceAccount:ftp-${var.environment}.iam.gserviceaccount.com",
  ]
}

# Add Read Only Access IAM binding here if needed
# Example:
# resource "google_storage_bucket_iam_binding" "read_only_access" {
#   bucket = google_storage_bucket.out_dlm_is.name
#   role   = "roles/storage.objectViewer"
#   members = [
#     "serviceAccount:your-read-only-service-account@your-project.iam.gserviceaccount.com",
#   ]
# }

variable "environment" {
  type = string
  description = "The environment (e.g., dev, prod)"
}