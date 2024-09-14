# Create CDN service account and grant access to backend bucket
# resource "google_service_account" "cdn-service-account" {
#     account_id      = var.service_account_id
#     display_name    = var.service_account_display_name
#     description     = "Service Account for Cloud CDN access" 
# }

resource "google_storage_bucket_iam_member" "cdn-sa" {
    bucket = var.bucket_name
    role   = "roles/storage.objectViewer"
    member = "serviceAccount:${var.cdn_default_sa}"
}

# Generate HMAC Keys for the SA

# resource "google_storage_hmac_key" "hmac-key-cdn-sa" {
#     service_account_email = google_service_account.cdn-service-account.email 
# }

# Store the key in secret manager
# resource "google_secret_manager_secret" "xdg-backend-bucket-key-secret" {
#     secret_id = var.key_name
#     replication {
#       auto {
        
#       }
#     }
# }

# resource "null_resource" "store-key-in-secret-manager" {
#     provisioner "local-exec" {
#       command = <<EOT

#       echo -n ${path.module}/file.json | gcloud secrets versions add ${google_secret_manager_secret.xdg-backend-bucket-key-secret.secret_id} --data-file=-
#       rm ${path.module}/file.json
#       EOT
#     }
# }
