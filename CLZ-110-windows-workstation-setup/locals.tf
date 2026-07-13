locals {
  # TODO: Générer le prefix 'clz-dev-clz110' en combinant les variables
  prefix = lower("${var.name_prefix}-${var.environment}-${var.lab_id}")

  # TODO: Déclarer les tags requis par le livre :
  # Project (Azure From Zero To Hero), Environment, ManagedBy (Terraform), et Lab
  tags = {
    Project     = "Azure From Zero To Hero"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Lab         = var.lab_id
  }
}