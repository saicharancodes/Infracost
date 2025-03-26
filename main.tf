# Configure the Google Cloud provider
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = "your-project-id" # Replace with your GCP project ID
  region  = "us-central1"      # Replace with your desired region
}

# Create a Google Cloud Storage bucket
resource "google_storage_bucket" "bucket" {
  name          = "your-unique-bucket-name" # Replace with a unique bucket name
  location      = "US"
  force_destroy = true

  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}

# Create a Google Compute Engine instance (VM)
resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size_gb = 50
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Include this section to give the VM a public IP address
    }
  }

  metadata_startup_script = "sudo apt-get update && sudo apt-get install -y nginx"

  service_account {
    scopes = ["cloud-platform"]
  }

}