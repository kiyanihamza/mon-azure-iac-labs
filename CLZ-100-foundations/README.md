# 🚀 Mission : Fondations Azure avec Terraform

## Objectif
Compléter les fichiers de configuration afin de déployer un groupe de ressources Azure hautement standardisé sans jamais écrire de texte brut ("hardcodé") dans vos ressources.

## ÉTAPES A RÉALISER :
1. Ouvrez `locals.tf` et complétez la variable locale `prefix` pour qu'elle génère dynamiquement `"clz-dev-clz100"`.
2. Ouvrez `resource-group.tf` et créez la ressource `azurerm_resource_group` en y liant votre préfixe, votre variable de région et vos tags locaux.
3. Ouvrez `outputs.tf` et configurez les sorties pour afficher dynamiquement le nom et la région de la ressource créée.

## COMMANDES DE VALIDATION :
```powershell
terraform init
terraform validate
terraform plan