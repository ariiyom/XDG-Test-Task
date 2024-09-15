terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 6.0.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version = "~> 6.0.0"
    }
  }
}

provider "google" {
  project = var.project_name
  region  = var.region
}

provider "google-beta" {
  project = var.project_name
  region  = var.region
}