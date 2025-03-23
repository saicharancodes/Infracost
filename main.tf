# Configure the Google Cloud Provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = "<YOUR_PROJECT_ID>" # Replace with your GCP project ID
  region  = "us-central1"      # Replace with your desired region
}

# Create a Google Cloud Storage Bucket
resource "google_storage_bucket" "default" {
  name          = "<YOUR_BUCKET_NAME>" # Replace with a unique bucket name
  location      = "US"
  force_destroy = true # Allows deletion of non-empty buckets

  # Optional: Set bucket policy if needed
  # uniform_bucket_level_access = true 
}

# Create a Google Compute Engine instance (VM)
resource "google_compute_instance" "default" {
  name         = "default-vm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default" # Use the default VPC network
  }
}