locals {
  region          = var.region
  project         = var.project_name
  project_num     = var.project_number
  custom_domain   = "koikonkorras.store" # Replace this value by a domain you own
}

module "apis" {
    source = "./modules/apis"
    project_id = local.project
    google_apis = [
        "cloudapis.googleapis.com",
        "compute.googleapis.com",
        "dns.googleapis.com",
        "iam.googleapis.com",
        "certificatemanager.googleapis.com",
        "domains.googleapis.com"
    ]
}

module "gcs" {
  source      = "./modules/gcs"
  bucket_name = "${local.project}-private"
}

module "dns" {
  source                      = "./modules/dns"
  external_lb_name            = "${local.project}-external-lb"
  custom_domain_zone          = "${local.project}-custom-domain-zone"
  custom_domain               = "${local.custom_domain}." 
  custom_domain_a_record_name = "${local.project}.${local.custom_domain}."
  
  depends_on  = [ module.apis ]
}

module "lb" {
  source                = "./modules/lb"
  backend_name          = "${local.project}-backend-bucket"
  backend_bucket_name   = module.gcs.bucket_name
  url_map               = "${local.project}-url-map" 
  cert_name             = "${local.project}-cert" 
  domains               = ["${local.project}.${local.custom_domain}"] 
  http_proxy            = "${local.project}-http-proxy"
  https_proxy           = "${local.project}-https-proxy"
  http_forwarding_rule  = "${local.project}-http-forwarding-rule"
  https_forwarding_rule = "${local.project}-https-forwarding-rule"
  ip_address            = module.dns.external-load-balancer-ip 
}