output "id" {
  description = "ID of the advanced certificate pack."
  value       = cloudflare_certificate_pack.this.id
}

output "status" {
  description = "Current Cloudflare status of the advanced certificate pack."
  value       = cloudflare_certificate_pack.this.status
}
