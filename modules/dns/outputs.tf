output "external-load-balancer-ip" {
    value = google_compute_global_address.lb-address.address
}

output "dns-zone-nameservers" {
    value = google_dns_managed_zone.custom-domain-zone.name_servers
}