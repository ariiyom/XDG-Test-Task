locals {
  region          = var.region
  project         = var.project_name
  project_num     = var.project_number
  custom_domain   = var.custom_domain
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
        "secretmanager.googleapis.com",
        "storage-component.googleapis.com"
    ]
}

module "gcs" {
  source      = "./modules/gcs"
  bucket_name = "${local.project}-private"

  depends_on = [ module.apis ]
}

module "dns" {
  source                      = "./modules/dns"
  external_lb_address         = "${local.project}-external-lb"                #LB external IP used for zone A record
  custom_domain_zone          = "${local.project}-custom-domain-zone"
  custom_domain               = "${local.custom_domain}." 
  custom_domain_a_record_name = "${local.project}.${local.custom_domain}."
  
  depends_on  = [ module.apis ]
}

module "cdn" {
  source                = "./modules/cdn"
  backend_name          = "${local.project}-backend-bucket"
  backend_bucket_name   = module.gcs.bucket_name
  key_name              = "${local.project}-cdn-key" 

  depends_on = [ module.apis ]
}

module "lb" {
  source                = "./modules/lb"
  backend_bucket_link   = module.cdn.backend_bucket_self_link
  url_map               = "${local.project}-url-map" 
  cert_name             = "${local.project}-cert" 
  domains               = ["${local.project}.${local.custom_domain}"] 
  http_proxy            = "${local.project}-http-proxy"
  https_proxy           = "${local.project}-https-proxy"
  http_forwarding_rule  = "${local.project}-http-forwarding-rule"
  https_forwarding_rule = "${local.project}-https-forwarding-rule"
  ip_address            = module.dns.external-load-balancer-ip 

  depends_on  = [ module.apis, module.cdn, module.dns ]
}

module "iam" {
  source                            = "./modules/iam"
  bucket_name                       = module.gcs.bucket_name 
  cdn_default_sa                    = "service-${local.project_num}@cloud-cdn-fill.iam.gserviceaccount.com" # Default CDN SA 
  
  depends_on = [ module.apis, module.gcs, module.cdn ]
}

module "url" {
  source              = "./modules/url"
  project_id          = local.project
  bucket_name         = module.gcs.bucket_name
  secret_name         = module.cdn.key-id 
  url_prefix          = "https://${local.project}.${local.custom_domain}"
  expiration          = "18000s" # 5hrs, can be changed according to needs

  depends_on = [ module.gcs, module.cdn, module.lb ]
}