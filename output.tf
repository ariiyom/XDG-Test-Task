output "xdg-private-bucket" {
    value = module.gcs.bucket_name
}

output "xdg-load-balancer-ip" {
    value = module.dns.external-load-balancer-ip
}

output "xdg-custom-zone-nameservers" {
    value = module.dns.dns-zone-nameservers
}

output "xdg-backend-bucket" {
    value = module.cdn.backend_bucket
}

output "xdg-load-balancer-backend-name" {
    value = module.cdn.lb-backend_name
}

# output "xdg-private-bucket-member" {
#     value = module.iam.bucket_member
# }