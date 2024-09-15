# Grant Access to CDN's default SA
resource "google_storage_bucket_iam_member" "cdn-sa" {
    bucket = var.bucket_name
    role   = "roles/storage.objectViewer"
    member = "serviceAccount:${var.cdn_default_sa}"
}
