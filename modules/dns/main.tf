# Reserve global external IP
resource "google_compute_global_address" "lb-address" {
    name            = var.external_lb_address
    address_type    = "EXTERNAL"
    ip_version      = "IPV4"
}

# Creates a zone for the custom domain that you own. Once provisioned, update your domain's nameservers with those provided by Cloud DNS
# After you update nameservers, propagation will take some time
resource "google_dns_managed_zone" "custom-domain-zone" {
    name        = var.custom_domain_zone
    dns_name    = var.custom_domain
}

# Create A record and point it to LB external IP
resource "google_dns_record_set" "custom-domain-a-record" {
    name            = var.custom_domain_a_record_name 
    managed_zone    = google_dns_managed_zone.custom-domain-zone.name
    type            = "A"
    ttl             = 300
    rrdatas         = [google_compute_global_address.lb-address.address]
}