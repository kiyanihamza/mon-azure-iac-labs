# 🧠 Fiche de Révision : Architecture IaC & Séparation des Responsabilités (Terraform)

Ce document résume l'architecture moderne d'un projet Terraform propre, modulaire et aligné sur les exigences de **Gouvernance Cloud & FinOps** en entreprise. 

---

## 🎯 Le Concept Clé : "Separation of Concerns" (Séparation des Responsabilités)
En production, regrouper tout le code dans un seul fichier est une mauvaise pratique majeure. Structurer son projet en plusieurs fichiers spécialisés permet de rendre l'infrastructure **lisible, modulaire, sécurisée et facilement extensible** par plusieurs collaborateurs.

---

## 🏗️ Anatomie d'un Dossier Terraform Standardisé

Chaque fichier possède un rôle unique, étanche et prévisible :

| Fichier | Catégorie | Rôle Clé | Spécificités Techniques |
| :--- | :--- | :--- | :--- |
| **`versions.tf`** | **Le "Quoi"** | Verrouille les contraintes logicielles. | Définit la version minimale de Terraform et les versions requises des providers (ex: AzureRM `~> 4.0`). |
| **`providers.tf`** | **Le "Qui"** | Configure l'accès physique à Azure. | Gère la liaison d'authentification et l'abonnement actif (via `subscription_id = var.subscription_id`). |
| **`variables.tf`** | **L'Entrée (Inputs)** | Reçoit les paramètres bruts extérieurs. | **Statique & Sécurisé :** Pas de calculs. Doit inclure un `type`, une `description` et un bloc de `validation {}` pour bloquer les erreurs de frappe à la source. |
| **`locals.tf`** | **Le Cerveau** | Nettoie, combine et centralise l'intelligence. | **Dynamique :** Utilise les fonctions HCL (`lower()`, `replace()`, `substr()`) pour générer le préfixe de nommage et la carte (map) globale des **Tags FinOps**. |
| **`resource-group.tf`** | **Le Physique** | Déclare la ressource Azure à déployer. | **Clean Code :** Aucune valeur codée en dur (hardcoded). Le nom appelle `${local.prefix}-rg` et les tags appellent `local.tags`. |
| **`outputs.tf`** | **La Sortie** | Expose les résultats constatés après création. | Transforme les données réelles issues d'Azure en variables de sortie pour d'autres configurations ou pipelines. |
| **`terraform.tfvars.example`** | **Le Modèle** | Documente la structure des entrées. | Fichier d'exemple anonymisé et partagé sur GitHub. Ne contient **aucun secret** (les vrais identifiants vont dans un fichier local `terraform.tfvars` ignoré par Git). |

---

## 🧠 Focus Gouvernance & FinOps (Leçons Apprises)

### 1. Comment on automatise la Gouvernance Cloud ?
* **La standardisation du Nommage :** Les noms de ressources sont générés dynamiquement dans `locals.tf` (ex: `clz-dev-clz150-rg`). Si vous devez ajouter d'autres ressources (ex: un réseau virtuel `virtual-network.tf`), elles utiliseront les mêmes variables calculées (`local.prefix`) pour garantir une nomenclature 100 % cohérente.
* **Le Tagging centralisé (FinOps) :** Les tags obligatoires (`Project`, `Environment`, `ManagedBy = "Terraform"`, `Lab`) sont centralisés dans `locals.tf`. Si l'équipe financière demande d'ajouter un tag `CostCenter`, il suffit de modifier **une seule ligne de code** dans `locals.tf` pour que l'intégralité de l'infrastructure en hérite automatiquement.
* **La Barrière de Sécurité (`validation {}`) :** Le bloc de validation de variables intercepte les erreurs humaines avant que Terraform ne tente de provisionner quoi que ce soit sur Azure (ex: interdire d'écrire `deev` ou `prood` au lieu de `dev` ou `prod`).

---

## 💬 Préparation à l'Entretien (Ce qu'il faut répondre au recruteur)

**Question du recruteur :** *"Comment organisez-vous vos fichiers dans un projet Terraform ?"*

**Votre réponse :**
> *"Je bannis systématiquement les fichiers monolithiques. J'applique le principe de séparation des responsabilités :
> 1. J'isole les restrictions de versions logicielles dans `versions.tf` et la configuration d'accès dans `providers.tf`.
> 2. Je déclare des variables d'entrée strictement typées et auto-validées (`validation`) dans `variables.tf`.
> 3. Je centralise toute l'intelligence de nommage et de tagging FinOps dans un fichier `locals.tf` en utilisant des fonctions de manipulation de chaînes (`lower`, `replace`, `substr`).
> 4. Mes fichiers de ressources (comme `resource-group.tf`) restent parfaitement épurés (Clean Code) car ils consomment uniquement les variables calculées dans mes locals.
> Cette structure modulaire me permet d'étendre facilement l'infrastructure (ex: ajouter du réseau ou du compute) sans jamais dupliquer ma logique de gouvernance."*
