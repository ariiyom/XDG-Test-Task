resource "google_storage_bucket" "xdg-private-bucket" {
    name                            = var.bucket_name
    location                        = var.location
    force_destroy                   = true
    uniform_bucket_level_access     = true
    public_access_prevention        = "enforced"
}

resource "null_resource" "upload-files" {
    provisioner "local-exec" {
      
      command = "gsutil cp -r ${path.module}/content/* gs://${google_storage_bucket.xdg-private-bucket.id}"
    }

    depends_on = [ google_storage_bucket.xdg-private-bucket ]
}