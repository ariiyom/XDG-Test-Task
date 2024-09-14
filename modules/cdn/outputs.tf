output "backend_bucket" {
    value = google_compute_backend_bucket.xdg-backend-bucket.id
}

output "lb-backend_name" {
    value = google_compute_backend_bucket.xdg-backend-bucket.name
}