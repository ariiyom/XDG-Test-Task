resource "google_compute_url_map" "url_map" {
    name            = var.url_map
    default_service = var.backend_bucket_link

    host_rule {
      hosts = ["*"]
      path_matcher = "allpaths"
    }

    path_matcher {
      name = "allpaths"
      default_service = var.backend_bucket_link
    }
}

# Managed SSL certificate for custom domain
resource "google_compute_managed_ssl_certificate" "managed-certs" {
    provider = google-beta
    name    = var.cert_name 
    
    managed {
      domains = var.domains
    }
}

# HTTP/S Proxy to route incoming requests to URL Map
resource "google_compute_target_http_proxy" "http-proxy" {
    provider        = google-beta  
    name            = var.http_proxy
    url_map         = google_compute_url_map.url_map.id
}

resource "google_compute_target_https_proxy" "https-proxy" {
    provider         = google-beta
    name             = var.https_proxy 
    url_map          = google_compute_url_map.url_map.id
    ssl_certificates = [google_compute_managed_ssl_certificate.managed-certs.id] 

    depends_on = [ google_compute_managed_ssl_certificate.managed-certs ]
}

# Forward traffic to LB for HTTP/S load balancing
resource "google_compute_global_forwarding_rule" "http-forwarding-rule" {
    provider               = google-beta 
    name                   = var.http_forwarding_rule
    target                 = google_compute_target_http_proxy.http-proxy.id
    port_range             = 80
    ip_address             = var.ip_address
    load_balancing_scheme  = "EXTERNAL_MANAGED"
}

resource "google_compute_global_forwarding_rule" "https-forwarding-rule" {
    provider               = google-beta 
    name                   = var.https_forwarding_rule
    target                 = google_compute_target_https_proxy.https-proxy.id
    port_range             = 443
    ip_protocol            = "TCP"
    ip_address             = var.ip_address
    load_balancing_scheme  = "EXTERNAL_MANAGED"
}