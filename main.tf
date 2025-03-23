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

resource "google_storage_bucket_iam_binding" "read_only_access" {
  bucket = google_storage_bucket.out_dlm_is.name
  role   = "roles/storage.objectViewer"
  members = [
    "serviceAccount:${var.read_only_service_account}",
  ]
  count = var.read_only_service_account != "" ? 1 : 0
}


resource "google_storage_bucket_lifecycle_rule" "lifecycle_rules" {
  bucket = google_storage_bucket.out_dlm_is.name

  rule {
    action {
      type = "Delete"
    }
    condition {
      age_in_days = 120
    }
  }
  rule {
    action {
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition {
      age_in_days = 14
    }
  }
   rule {
    action {
      type = "SetStorageClass"
      storage_class = "COLDLINE"
    }
    condition {
      age_in_days = 90
    }
  }
}

variable "environment" {
  type        = string
  description = "The environment (e.g., dev, prod)"
}

variable "read_only_service_account" {
  type        = string
  description = "Service account with read-only access (optional)"
  default     = ""
}