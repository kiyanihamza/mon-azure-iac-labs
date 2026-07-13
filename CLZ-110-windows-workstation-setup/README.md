# 💻 Lab CLZ-110 : Windows Workstation Setup & Azure CLI Context

## 🎯 Objectif du Lab
L'objectif de ce chapitre est de valider l'environnement de travail local (PowerShell, VS Code, Git, Azure CLI) et sa capacité à interagir de manière sécurisée et disciplinée avec Azure. 

Ce lab met l'accent sur la gestion du **contexte d'abonnement Azure CLI** et l'adoption d'un workflow Terraform professionnel (formatage, plan sauvegardé et nettoyage systématique).

---

## 🏗️ Structure des Fichiers
Ce module est structuré de manière modulaire selon les bonnes pratiques :
* `versions.tf` : Déclare les contraintes de version de Terraform (`>= 1.6.0`) et des providers (AzureRM `~> 4.0` et Random `~> 3.6`).
* `providers.tf` : Configure le provider AzureRM en se liant dynamiquement à l'abonnement actif.
* `variables.tf` : Définit les variables d'entrée (environnement, région, préfixe).
* `locals.tf` : Calcule dynamiquement le préfixe (`clz-dev-clz110`) et génère les tags standardisés.
* `resource-group.tf` : Déploie le groupe de ressources de test.
* `outputs.tf` : Expose le nom et la localisation du groupe créé pour validation.
* `terraform.tfvars.example` : Modèle de variables pour l'usage local.

---

## 🚦 Guide d'Exécution (Workflow Discipliné)

Suivez scrupuleusement ces étapes dans votre terminal PowerShell depuis ce dossier :

### Étape 1 : Inspection et Configuration du Contexte Azure
Avant de lancer Terraform, validez toujours où vous pointez sur Azure :
```powershell
# 1. Connexion à Azure
az login

# 2. Vérifier l'abonnement actif
az account show

# 3. Lister les abonnements disponibles
az account list --output table

# 4. (Si nécessaire) Forcer l'abonnement cible
# az account set --subscription "VOTRE-SUBSCRIPTION-ID"