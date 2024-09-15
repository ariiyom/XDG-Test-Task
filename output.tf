output "xdg-private-bucket" {
    value = module.gcs.bucket_name
}

output "xdg-load-balancer-ip" {
    value = module.dns.external-load-balancer-ip
}

output "xdg-custom-zone-nameservers" {
    value = module.dns.dns-zone-nameservers
}

output "xdg-custom-domain-name" {
    value = module.dns.custom-domain-name
}

output "xdg-backend-bucket" {
    value = module.cdn.backend_bucket
}

output "xdg-backend-bucket-self-link" {
    value = module.cdn.backend_bucket_self_link
}

output "xdg-load-balancer-backend-name" {
    value = module.cdn.lb-backend_name
}

output "xdg-cdn-key-ref" {
    value = module.cdn.key-id
}

output "xdg-signed-url" {
    value = module.url.signed_url
}

output "xdg-private-bucket-member" {
    value = module.iam.bucket_member
}