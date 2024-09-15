# Configure Cloud CDN to use bucket as backend service for content caching
resource "google_compute_backend_bucket" "xdg-backend-bucket" {
    name            = var.backend_name
    bucket_name     = var.backend_bucket_name
    enable_cdn      = true 

    cdn_policy {
      cache_mode    = "CACHE_ALL_STATIC"
      client_ttl    = 3600
      default_ttl   = 3600
      max_ttl       = 86400 
    }
}

# Generate signed url key
resource "null_resource" "generate-signed-url-key" {
    provisioner "local-exec" {
        command = <<EOT
        head -c 16 /dev/urandom | base64 | tr '+/' '-_' > ${path.module}/file.txt
        EOT     
    }
    
    depends_on = [ google_compute_backend_bucket.xdg-backend-bucket ]
}

# Attach the key to backend bucket
resource "null_resource" "add-signed-url-key" {
    provisioner "local-exec" {
        command = <<EOT
        gcloud compute backend-buckets add-signed-url-key ${google_compute_backend_bucket.xdg-backend-bucket.name} --key-name ${var.key_name} --key-file ${path.module}/file.txt
        EOT
    }
    
    depends_on = [ google_compute_backend_bucket.xdg-backend-bucket ]
}

# Store the key value in secret manager
resource "google_secret_manager_secret" "xdg-backend-bucket-key-secret" {
    secret_id = var.key_name
    replication {
      auto {
        
      }
    }
}

resource "null_resource" "store-key-in-secret-manager" {
    provisioner "local-exec" {
      command = <<EOT
      echo "$(cat ${path.module}/file.txt)" | gcloud secrets versions add ${google_secret_manager_secret.xdg-backend-bucket-key-secret.secret_id} --data-file=-
      rm ${path.module}/file.txt
      EOT
    }

    depends_on = [ null_resource.generate-signed-url-key ]
}

