locals {
  # TODO: Écrire la formule pour le lab_code (passer var.lab_id en minuscule et remplacer "CLZ-" par "clz")
  lab_code = lower(replace(var.lab_id, "CLZ-", "clz"))

  # TODO: Construire le prefix en assemblant var.name_prefix, var.environment et local.lab_code séparés par des tirets
  prefix   = lower("${var.name_prefix}-${var.environment}-${local.lab_code}")

  tags = {
    Project     = "Azure From Zero To Hero"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Lab         = var.lab_id
  }
}