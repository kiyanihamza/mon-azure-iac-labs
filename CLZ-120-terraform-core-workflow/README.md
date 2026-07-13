# 🔄 Lab CLZ-120 : Le Core Workflow Terraform

## 🎯 Objectif
Maîtriser la routine de déploiement et de revue de code. Ce chapitre démontre pourquoi le déploiement de code via Terraform est infiniment supérieur et plus répétable que les clics manuels sur le portail Azure.

---

## 🚧 Les Portes de Contrôle (À exécuter dans l'ordre)

1. **Initialisation** : Prépare les plugins. Si ça échoue, on s'arrête.
   ```powershell
   terraform init