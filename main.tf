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

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age_in_days = 90
    }
  }

  lifecycle_rule {
    action {
      type = "SetStorageClass"
      storage_class = "NEARLINE"
    }
    condition {
      age_in_days = 7
    }
  }

   lifecycle_rule {
    action {
      type = "SetStorageClass"
      storage_class = "COLDLINE"
    }
    condition {
      age_in_days = 30
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

# Add Read Only Access Service Account Here
#resource "google_storage_bucket_iam_member" "read_only" {
#  bucket = google_storage_bucket.out_dlm_is.name
#  role   = "roles/storage.objectViewer"
#  member = "serviceAccount:<READ_ONLY_SERVICE_ACCOUNT>"
#}