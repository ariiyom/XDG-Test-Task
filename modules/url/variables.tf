variable "project_id" {
    type = string
}

variable "bucket_name" {
    type = string
}

variable "secret_name" {
    type = string
}

variable "expiration" {
    type = string
}

variable "url_prefix" {
    type = string
}

variable "secret_version" {
    type = string
    default = "latest"
}