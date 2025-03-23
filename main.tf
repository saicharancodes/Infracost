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
  project = "<YOUR_PROJECT_ID>" # Replace with your GCP Project ID
  region  = "us-central1"        # Default Region
}

# Create a Google Cloud Storage Bucket
resource "google_storage_bucket" "default_bucket" {
  name          = "<YOUR_BUCKET_NAME>" # Replace with your desired bucket name (must be globally unique)
  location      = "US"               # Default Location
  force_destroy = true             # Allows Terraform to delete the bucket even if it contains objects
}

# Create a Google Compute Engine instance (VM)
resource "google_compute_instance" "default_vm" {
  name         = "default-vm"
  machine_type = "e2-medium" #default machine size
  zone         = "us-central1-a" #default zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11" # Default OS image
    }
  }

  network_interface {
    network = "default" #default network

    access_config {
      # Include this section to give the VM a public IP address
    }
  }
}