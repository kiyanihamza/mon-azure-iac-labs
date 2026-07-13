# 💾 Lab CLZ-160 : Les Fondations du State et du Verrouillage (Locking)

## 🎯 Objectif Clair
**Comprendre le rôle critique du fichier d'état (State), maîtriser le cycle de vie des fichiers temporaires d'exécution et sécuriser le déploiement via le mécanisme de verrouillage (Locking).**

Ce lab met en lumière la mémoire interne de Terraform. L'objectif est d'assimiler pourquoi Terraform a besoin d'un historique local pour savoir ce qu'il gère, et pourquoi la manipulation manuelle de l'infrastructure ou des fichiers d'état locaux représente un danger critique en production.

---

## 📝 Résumé du Lab
Nous avons déployé un groupe de ressources unique `clz-dev-clz160-rg` dans la région `eastus2`. 

Lors de l'application du plan (`terraform apply`), Terraform a automatiquement généré un fichier local nommé `terraform.tfstate`. Ce fichier agit comme une passerelle cartographique : il associe l'adresse logique de notre code (`azurerm_resource_group.lab`) à l'identifiant unique réel généré par Azure dans le Cloud. 

---

## 💡 Leçons Apprises & Fiche de Révision (Questions d'Entretiens DevOps)

### 1. Qu'est-ce que le "State" et pourquoi est-il vital ?
*   **Le Concept** : Si vous créez manuellement un groupe de ressources sur le portail Azure, Terraform ignorera totalement son existence. Le State est l'unique source de vérité qui permet à Terraform de comparer votre code source, sa mémoire enregistrée, et l'état réel de votre Cloud (via un appel API "Read").
*   **La Règle d'Or** : On ne modifie **JAMAIS** le fichier `terraform.tfstate` à la main. Toute corruption de ce fichier rompt la liaison avec Azure.

### 2. Code Source vs Artefacts d'Exécution (Runtime Files)
Il faut faire une distinction stricte dans votre gestion de version Git :
*   **Fichiers Sources (À commiter)** : Les fichiers `.tf` et les fichiers d'exemples `.tfvars.example`. Ils décrivent l'architecture cible de manière agnostique.
*   **Fichiers Runtime (À bannir de Git via `.gitignore`)** : Le dossier `.terraform/`, les fichiers `.tfstate`, `.tfstate.backup` et les plans exportés (`tfplan`). Ces fichiers contiennent des informations d'exécution spécifiques à votre machine, des identifiants techniques, et potentiellement des secrets en clair.

### 3. Le Verrouillage du State (State Locking)
*   **Le Problème** : Que se passe-t-il si deux ingénieurs DevOps exécutent `terraform apply` en même temps sur le même projet ? Le fichier d'état sera corrompu par des écritures simultanées.
*   **La Solution** : Le mécanisme de *Locking* empêche toute opération d'écriture concurrente. Bien que ce lab utilise un état local, la règle reste stricte : une seule opération d'écriture (`apply` ou `destroy`) doit s'exécuter à la fois.

### 4. La discipline du dossier d'origine
Puisque l'état est stocké localement dans ce dossier, le nettoyage via `terraform destroy` doit **impérativement** être lancé depuis ce même dossier `CLZ-160-state-and-locking-basics`. Si vous supprimez la ressource à la main dans le portail Azure, le State local de Terraform sera désynchronisé ("déphasé") de la réalité d'Azure.

---

## 🚦 Runbook et Validation Visuelle

```powershell
# 1. Initialiser et valider la structure
terraform init
terraform validate

# 2. Générer le plan et l'appliquer
terraform plan -out tfplan
terraform apply tfplan

# 3. Observer l'apparition du fichier magique
# Un fichier 'terraform.tfstate' vient d'apparaître dans votre dossier !

# 4. Destruction propre via la mémoire de Terraform
terraform destroy -auto-approve