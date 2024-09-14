# Configure Cloud CDN to use bucket as backend service for content caching
resource "google_compute_backend_bucket" "xdg-backend-bucket" {
    name            = var.backend_name
    bucket_name     = var.backend_bucket_name
    enable_cdn      = true 
}

# Generate signed url key

# resource "null_resource" "generate-signed-url-key-1" {
#     provisioner "local-exec" {
#         command = <<EOT
#         touch ${path.module}/file.txt
#         head -c 16 /dev/urandom | base64 | tr +/ -_ > ${path.module}/file.txt
#         EOT     
#     }
    
#     depends_on = [ google_compute_backend_bucket.xdg-backend-bucket ]
# }

# Attach it to backend bucket
# resource "null_resource" "add-signed-url-key" {
#     provisioner "local-exec" {
#         command = <<EOT
#         gcloud compute backend-buckets add-signed-url-key ${google_compute_backend_bucket.xdg-backend-bucket.name} --key-name ${var.key_name} --key-file ${path.module}/file.txt
#         EOT
#     }
    
#     depends_on = [ google_compute_backend_bucket.xdg-backend-bucket ]
# }

# # Store the key value in secret manager
# resource "google_secret_manager_secret" "xdg-backend-bucket-key-secret" {
#     secret_id = var.key_name
#     replication {
#       auto {
        
#       }
#     }
# }

# resource "null_resource" "store-key-in-secret-manager-1" {
#     provisioner "local-exec" {
#       command = <<EOT
#       echo "$(cat ${path.module}/file.txt)" | gcloud secrets versions add ${google_secret_manager_secret.xdg-backend-bucket-key-secret.secret_id} --data-file=-
#       rm ${path.module}/file.txt
#       EOT
#     }

#     depends_on = [ null_resource.generate-signed-url-key-1 ]
# }

