output "xdg-private-bucket" {
    value = module.gcs.bucket_name
}

output "xdg-load-balancer-ip" {
    value = module.dns.external-load-balancer-ip
}

output "xdg-custom-zone-nameservers" {
    value = module.dns.dns-zone-nameservers
}