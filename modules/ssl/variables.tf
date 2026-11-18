variable "zone_id" {
  description = "ID of the Cloudflare zone where the certificate pack is ordered."
  type        = string
  nullable    = false
}

variable "type" {
  description = "Certificate pack type. The supported value is advanced."
  type        = string
  default     = "advanced"
  nullable    = false

  validation {
    condition     = var.type == "advanced"
    error_message = "Certificate pack type must be advanced."
  }
}

variable "hosts" {
  description = "Set of 1 to 50 hostnames covered by the pack, including the zone apex."
  type        = set(string)
  nullable    = false

  validation {
    condition     = length(var.hosts) >= 1 && length(var.hosts) <= 50
    error_message = "Provide between 1 and 50 hostnames, including the zone apex."
  }
}

variable "validation_method" {
  description = "Domain control validation method for the order, such as txt, http, or email."
  type        = string
  nullable    = false
}

variable "validity_days" {
  description = "Certificate validity in days. Choose a value supported by the selected certificate authority and Cloudflare plan."
  type        = number
  nullable    = false
}

variable "certificate_authority" {
  description = "Certificate authority for the order. Supported values are google, lets_encrypt, and ssl_com."
  type        = string
  nullable    = false
}

variable "cloudflare_branding" {
  description = "Whether to include Cloudflare branding in the certificate order."
  type        = bool
  default     = null
}
