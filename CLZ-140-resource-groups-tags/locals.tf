locals {
  lab_number     = replace(var.lab_id, "CLZ-", "")
  lab_code       = lower(replace(var.lab_id, "CLZ-", "clz"))
  prefix         = lower("${var.name_prefix}-${var.environment}-${local.lab_code}")
  compact_prefix = substr(replace(local.prefix, "-", ""), 0, 18)

  # La carte de tags standardisée pour l'audit et la facturation
  tags = {
    Project     = "Azure From Zero To Hero"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Lab         = var.lab_id
  }
}