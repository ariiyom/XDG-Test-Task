output "backend_bucket" {
    value = google_compute_backend_bucket.xdg-backend-bucket.id
}

output "backend_bucket_self_link" {
    value =  google_compute_backend_bucket.xdg-backend-bucket.self_link
}

output "lb-backend_name" {
    value = google_compute_backend_bucket.xdg-backend-bucket.name
}

output "key-id" {
    value = google_secret_manager_secret.xdg-backend-bucket-key-secret.secret_id
}