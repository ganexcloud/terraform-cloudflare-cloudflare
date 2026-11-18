mock_provider "cloudflare" {}

run "direct_ssl" {
  command = plan

  module {
    source = "./modules/ssl"
  }

  variables {
    zone_id               = "00000000000000000000000000000000"
    hosts                 = ["example.com", "*.example.com"]
    certificate_authority = "lets_encrypt"
    validation_method     = "txt"
    validity_days         = 90
    cloudflare_branding   = false
  }

  assert {
    condition = (
      cloudflare_certificate_pack.this.type == "advanced" &&
      cloudflare_certificate_pack.this.hosts == toset(["example.com", "*.example.com"]) &&
      cloudflare_certificate_pack.this.cloudflare_branding == false
    )
    error_message = "The direct submodule must order an advanced pack with the supplied hostnames and branding."
  }
}

run "root_ssl_is_optional" {
  command = plan

  assert {
    condition     = length(output.certificate_packs) == 0
    error_message = "The root must leave SSL disabled when certificate_packs is omitted."
  }
}

run "root_ssl_uses_logical_keys" {
  command = plan

  variables {
    certificate_packs = {
      primary = {
        zone_id               = "00000000000000000000000000000000"
        hosts                 = ["example.com", "*.example.com"]
        certificate_authority = "lets_encrypt"
        validation_method     = "txt"
        validity_days         = 90
      }
      secondary = {
        zone_id               = "11111111111111111111111111111111"
        hosts                 = ["example.net"]
        certificate_authority = "google"
        validation_method     = "txt"
        validity_days         = 14
        cloudflare_branding   = false
      }
    }
  }

  assert {
    condition     = toset(keys(output.certificate_packs)) == toset(["primary", "secondary"])
    error_message = "The root must expose a pack for each logical key."
  }

  assert {
    condition     = toset(keys(output.certificate_packs["primary"])) == toset(["id", "status"])
    error_message = "Each configured pack must expose its ID and status."
  }
}

run "reject_empty_hosts" {
  command = plan

  module {
    source = "./modules/ssl"
  }

  variables {
    zone_id               = "00000000000000000000000000000000"
    hosts                 = []
    certificate_authority = "lets_encrypt"
    validation_method     = "txt"
    validity_days         = 90
  }

  expect_failures = [var.hosts]
}

run "reject_legacy_pack_type" {
  command = plan

  module {
    source = "./modules/ssl"
  }

  variables {
    zone_id               = "00000000000000000000000000000000"
    type                  = "dedicated_custom"
    hosts                 = ["example.com"]
    certificate_authority = "lets_encrypt"
    validation_method     = "txt"
    validity_days         = 90
  }

  expect_failures = [var.type]
}
