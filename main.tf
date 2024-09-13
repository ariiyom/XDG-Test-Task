locals {
  region    = var.region
  project   = var.project_name
}

module "apis" {
    source = "./modules/apis"
    project_id = local.project
    google_apis = [
        "cloudapis.googleapis.com",
        "compute.googleapis.com",
        "dns.googleapis.com",
        "iam.googleapis.com",
        "certificatemanager.googleapis.com"
    ]
}