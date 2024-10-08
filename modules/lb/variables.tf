variable "backend_bucket_link" {
    type = string
}

variable "url_map" {
    type = string
}

variable "domains" {
    type = list(string)
}

variable "cert_name" {
    type = string
}

variable "http_proxy" {
    type = string
}

variable "https_proxy" {
    type = string
}

variable "http_forwarding_rule" {
    type = string
}

variable "https_forwarding_rule" {
    type = string
}

variable "ip_address" {
    type = string
}