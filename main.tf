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
        "domains.googleapis.com",
        "networkservices.googleapis.com",
        "secretmanager.googleapis.com"
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

module "cdn" {
  source                = "./modules/cdn"
  backend_name          = "${local.project}-backend-bucket"
  backend_bucket_name   = module.gcs.bucket_name
  key_name              = "${local.project}-backend-key" 

  depends_on = [ module.apis ]
}

# Cloud CDN uses the same service account as Google Cloud Load Balancers
# module "iam" {
#   source                            = "./modules/iam"
#   bucket_name                       = module.gcs.bucket_name 
#   # service_account_id                = "${local.project}-cdn-sa"
#   # service_account_display_name      = "${local.project} CDN SA"
#   # key_name                          = "${local.project}-hmac-key" 
#   cdn_default_sa                  = "service-${local.project_num}@cloud-cdn-fill.iam.gserviceaccount.com"
  
#   depends_on = [ module.cdn ]
# }

module "lb" {
  source                = "./modules/lb"
  backend_bucket        = module.cdn.backend_bucket
  url_map               = "${local.project}-url-map" 
  cert_name             = "${local.project}-cert" 
  domains               = ["${local.project}.${local.custom_domain}"] 
  http_proxy            = "${local.project}-http-proxy"
  https_proxy           = "${local.project}-https-proxy"
  http_forwarding_rule  = "${local.project}-http-forwarding-rule"
  https_forwarding_rule = "${local.project}-https-forwarding-rule"
  ip_address            = module.dns.external-load-balancer-ip 

  depends_on  = [ module.apis,module.cdn ]
}

