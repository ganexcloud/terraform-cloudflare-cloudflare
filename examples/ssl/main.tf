module "ssl" {
  source = "../../modules/ssl"

  zone_id               = "00000000000000000000000000000000"
  hosts                 = ["example.com", "*.example.com"]
  certificate_authority = "lets_encrypt"
  validation_method     = "txt"
  validity_days         = 90
  cloudflare_branding   = false
}
