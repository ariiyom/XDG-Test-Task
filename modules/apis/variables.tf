variable "google_apis" {
    type = list(string)
    description = "List of API services to enable"
}

variable "project_id" {
    type = string
    description = "GCP Project ID"
}