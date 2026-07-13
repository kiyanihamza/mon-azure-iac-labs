# 🔐 Lab CLZ-130 : Authentification et Étanchéité du Contexte Azure

## 🎯 Objectif Clair
**Valider et sécuriser la liaison d'authentification entre Terraform et Azure.** 

Ce lab démontre de manière concrète qu'un code Terraform peut être syntaxiquement parfait, mais totalement destructeur s'il est exécuté sur le mauvais abonnement Azure. L'objectif est de mettre en place une barrière de sécurité locale en utilisant les variables de contexte et les outils d'inspection d'Azure CLI.

---

## 📝 Résumé du Lab
Nous avons déployé un groupe de ressources minimal (`clz-dev-clz130-rg`) dans la région `eastus2`. Plutôt que de coder en dur (hardcoder) nos identifiants Azure — ce qui est une faille de sécurité majeure —, nous avons configuré le bloc `provider "azurerm"` pour qu'il s'aligne dynamiquement sur la session active de notre terminal local (`az login`). 

Toute la mécanique repose sur une variable `subscription_id` initialisée à `null`, forçant Terraform à lire le contexte d'authentification actif d'Azure CLI.

---

## 💡 Leçons Apprises (Ce qu'il faut retenir)

* **La validité du code n'est pas une garantie de ciblage** : La commande `terraform validate` vérifie uniquement la syntaxe HCL. Elle ne sait pas si vous pointez sur votre abonnement de Production ou de Sandbox. Le contrôle d'identité (`az account show`) est la véritable première porte de sécurité avant chaque modification.
* **Le danger des valeurs par texte `"null"` vs `null`** : Nous avons appris à maîtriser les types de données Terraform. Passer la chaîne de caractères `"null"` induit le provider en erreur, alors que le mot-clé système `null` indique une absence de valeur, activant ainsi le comportement dynamique d'Azure CLI.
* **Séparation stricte des secrets (Zéro fuite)** : Les fichiers de configuration partagés sur GitHub (comme ce dépôt) ne doivent contenir **aucune** donnée sensible (Tenant ID, Subscription ID, Client Secret). Les valeurs réelles de test doivent rester dans un fichier local `terraform.tfvars` strictement banni de Git via le `.gitignore`.
* **L'importance du plan figé (`-out tfplan`)** : En entreprise, on n'applique jamais un plan calculé à la volée. Figer le plan dans un fichier permet de l'inspecter (vérifier la présence des tags, le nom de la ressource et le nombre exact d'éléments créés) avant de donner le feu vert à l'infrastructure.

---

## 🚦 Guide d'Exécution Rapide

```powershell
# 1. Vérification humaine du contexte Azure
az account show
az account list --output table

# 2. Cycle de déploiement discipliné
terraform init
terraform fmt
terraform validate
terraform plan -out tfplan
terraform apply tfplan

# 3. Nettoyage immédiat
terraform destroy -auto-approve