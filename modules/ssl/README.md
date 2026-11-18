# SSL

Orders a Cloudflare-managed edge TLS certificate pack through
[Advanced Certificate Manager](https://developers.cloudflare.com/ssl/edge-certificates/advanced-certificate-manager/).
The zone needs the Advanced Certificate Manager add-on. Include the zone apex in `hosts` and use
a validity period supported by the selected [certificate authority](https://developers.cloudflare.com/ssl/reference/certificate-authorities/).

Call `ganexcloud/cloudflare/cloudflare//modules/ssl` directly, or use the root module's
`certificate_packs` map. See the [direct example](../../examples/ssl) and the
[root example](../../examples/complete).

## Adopt an existing pack

For direct adoption, keep the existing module label and any instance key when changing its source.
The resource keeps the address suffix `cloudflare_certificate_pack.this`. Supply the existing
certificate authority, validation method, and validity explicitly. Pass `cloudflare_branding` as a
boolean when configured.

For adoption through the consolidated root, add a `moved` block in the consumer configuration.
Replace the module labels and map key below with the addresses from that workspace.

```hcl
moved {
  from = module.cloudflare_ssl.cloudflare_certificate_pack.this
  to   = module.cloudflare.module.ssl["example"].cloudflare_certificate_pack.this
}
```

The [provider migration guide](https://github.com/cloudflare/terraform-provider-cloudflare/blob/main/docs/guides/version-5-migration.md)
covers state upgrades from v4. Verify v3 state compatibility in the consumer workspace. Run
`terraform init -upgrade`, `terraform validate`, `terraform plan -out=tfplan`, and
`terraform show -json tfplan`. Proceed with adoption only after confirming the plan has no creation,
deletion, or replacement of the existing pack.

If the existing pack uses a legacy CA such as `digicert`, plan a
[two-phase rotation](https://developers.cloudflare.com/ssl/reference/certificate-rotation/)
with a supported CA. Terraform selects one version of the Cloudflare provider for the whole
configuration. While the old pack is managed by the legacy v3 module, order the replacement
using a separate Terraform configuration and state with provider v5. Confirm that the replacement
reports `active` and covers the intended hostnames before retiring the old pack. When both
packs can already use the same v5 provider, use a separate module instance or map key for the
replacement in the same configuration.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.0 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | >= 5.25.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | >= 5.25.0, < 6.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_certificate_pack.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/certificate_pack) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificate_authority"></a> [certificate\_authority](#input\_certificate\_authority) | Certificate authority for the order. Supported values are google, lets\_encrypt, and ssl\_com. | `string` | n/a | yes |
| <a name="input_cloudflare_branding"></a> [cloudflare\_branding](#input\_cloudflare\_branding) | Whether to include Cloudflare branding in the certificate order. | `bool` | `null` | no |
| <a name="input_hosts"></a> [hosts](#input\_hosts) | Set of 1 to 50 hostnames covered by the pack, including the zone apex. | `set(string)` | n/a | yes |
| <a name="input_type"></a> [type](#input\_type) | Certificate pack type. The supported value is advanced. | `string` | `"advanced"` | no |
| <a name="input_validation_method"></a> [validation\_method](#input\_validation\_method) | Domain control validation method for the order, such as txt, http, or email. | `string` | n/a | yes |
| <a name="input_validity_days"></a> [validity\_days](#input\_validity\_days) | Certificate validity in days. Choose a value supported by the selected certificate authority and Cloudflare plan. | `number` | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | ID of the Cloudflare zone where the certificate pack is ordered. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the advanced certificate pack. |
| <a name="output_status"></a> [status](#output\_status) | Current Cloudflare status of the advanced certificate pack. |
<!-- END_TF_DOCS -->
