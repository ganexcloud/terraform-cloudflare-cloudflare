module "cloudflare" {
  source = "../.."

  records = {
    example = {
      records = [{ name = "www", type = "CNAME", value = "origin.example.invalid" }]
      zone_id = "00000000000000000000000000000000"
    }
  }

  certificate_packs = {
    example = {
      zone_id               = "00000000000000000000000000000000"
      hosts                 = ["example.com", "*.example.com"]
      certificate_authority = "lets_encrypt"
      validation_method     = "txt"
      validity_days         = 90
    }
  }
}
