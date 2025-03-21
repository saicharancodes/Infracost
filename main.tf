resource "google_storage_bucket" "out_dlm_is" {
  name                        = "out-dlm-is-${terraform.workspace}"
  project                     = "network-tkoff-${terraform.workspace}"
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

  versioning {
    enabled = false #  Consider enabling versioning for data recovery purposes
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age_in_days              = 90
      storage_class            = ["NEARLINE", "COLDLINE"]
      created_before           = null
      custom_time_before       = null
      days_since_custom_time = null
      days_since_noncurrent_time = null
      noncurrent_time_before   = null
      num_newer_versions       = null
    }
  }
}

resource "google_storage_bucket_iam_member" "read_write_tf" {
  bucket = google_storage_bucket.out_dlm_is.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:tf-${terraform.workspace}.iam.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "read_write_ftp" {
  bucket = google_storage_bucket.out_dlm_is.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:ftp-${terraform.workspace}.iam.gserviceaccount.com"
}

# Add read only access for other service accounts here
# Example
# resource "google_storage_bucket_iam_member" "read_only_sa" {
#   bucket = google_storage_bucket.out_dlm_is.name
#   role   = "roles/storage.objectViewer"
#   member = "serviceAccount:other-project-sa@other-project.iam.gserviceaccount.com"
# }