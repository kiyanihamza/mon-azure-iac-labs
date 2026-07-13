locals {
  # TODO: Extraire uniquement le numéro du lab (ex: "120") en supprimant "CLZ-" de var.lab_id
  lab_number = replace(var.lab_id, "CLZ-", "")

  # TODO: Passer le lab_id en minuscule (ex: "clz-120")
  lab_code   = lower(replace(var.lab_id, "CLZ-", "clz"))

  # TODO: Construire le préfixe final en combinant var.name_prefix, var.environment et local.lab_code
  prefix     = lower("${var.name_prefix}-${var.environment}-${local.lab_code}")

  # TODO: Créer un préfixe compact sans tirets, limité à 18 caractères
  compact_prefix = substr(replace(local.prefix, "-", ""), 0, 18)

  tags = {
    Project     = "Azure From Zero To Hero"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Lab         = var.lab_id
  }
}