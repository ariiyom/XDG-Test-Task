# Retrive CDN key from secret manager
resource "null_resource" "retrieve-key" {
    provisioner "local-exec" {
        command = <<EOT
        KEY=$(gcloud secrets versions access ${var.secret_version} --secret=${var.secret_name} --project=${var.project_id})
        echo "$KEY" > ${path.module}/key.txt
        EOT
    }

    triggers = {
      always_run = "${timestamp()}"
    }
}

# Retrieve GCS objects
resource "null_resource" "retrieve-gcs-object" {
    provisioner "local-exec" {
        command = "gsutil ls gs://${var.bucket_name}/ > ${path.module}/objects.txt"
    }

    triggers = {
      always_run = "${timestamp()}"
    }
}

# Generate signed URL
resource "null_resource" "generate-signed-url" {
    provisioner "local-exec" {
        command =  <<EOT
        bash ${path.module}/generate_signed_url.sh ${path.module}/objects.txt ${var.url_prefix} ${var.secret_name} ${path.module}/key.txt ${var.expiration} > ${path.module}/url.txt
        rm ${path.module}/key.txt ${path.module}/objects.txt
        EOT
    }

    triggers = {
      always_run = "${timestamp()}"
    }

    depends_on = [ null_resource.retrieve-key, null_resource.retrieve-gcs-object ]
}

data "local_file" "signed-url" {
    filename = "${path.module}/url.txt"

    depends_on = [ null_resource.generate-signed-url ]
}
