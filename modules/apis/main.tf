resource "google_project_service" "google_apis" {
    count = length(var.google_apis)
    project = var.project_id
    service = var.google_apis[count.index]
}