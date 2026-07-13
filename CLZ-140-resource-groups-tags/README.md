# 🏷️ Lab CLZ-140 : Standardisation du Nommage, Tags et Gouvernance

## 🎯 Objectif Clair
**Automatiser et verrouiller les règles de nommage et de marquage (tags) d'une infrastructure Azure pour garantir l'auditabilité, le suivi des coûts et le nettoyage à grande échelle.**

Ce lab démontre comment transformer des règles de gouvernance cloud (souvent oubliées lorsqu'elles sont manuelles) en un modèle de conception logiciel strict, répétable et auto-validé par Terraform.

---

## 📝 Résumé du Lab
Nous avons déployé un groupe de ressources nommé de manière dynamique `clz-dev-clz140-rg` dans la région `eastus2`. 

Plutôt que d'écrire manuellement les noms et les étiquettes dans le bloc de ressource, nous avons configuré des formules dans `locals.tf` et des blocs de restriction dans `variables.tf`. Le code de la ressource reste ainsi totalement épuré, car il se contente de consommer des variables calculées en amont.

---

## 💡 Leçons Apprises & Fiches de Révision (Essentiel DevOps)

### 1. La Validation de Variables (`validation {}`)
*   **Pourquoi c'est concret** : Une simple faute de frappe dans le nom d'un environnement (ex: `deev` au lieu de `dev`) peut corrompre toute une nomenclature ou fausser les rapports de facturation Azure.
*   **La solution** : Le bloc `validation` intercepte l'erreur **avant** même que Terraform ne contacte Azure. Si l'utilisateur saisit une valeur hors de la liste `["dev", "test", "prod"]`, Terraform stoppe net le workflow et affiche l'erreur personnalisée.

### 2. L'art de la manipulation de chaînes (`locals.tf`)
Nous avons utilisé des fonctions intégrées puissantes pour fabriquer une identité d'infrastructure :
*   `replace()` : Nettoie les chaînes (ex: transforme `CLZ-140` en `clz140`).
*   `lower()` : Force la mise en minuscule, indispensable car Azure est sensible à la casse sur certains services.
*   `substr()` : Découpe la chaîne pour générer un `compact_prefix` de 18 caractères maximum. C'est une compétence clé pour le futur, car certains services Azure (comme les comptes de stockage) interdisent les tirets et sont limités en caractères.

### 3. Les Tags ne sont pas cosmétiques (Gouvernance FinOps)
Les 4 tags configurés ont un but opérationnel précis :
*   `Project` : Regroupe logiquement les ressources du projet.
*   `Environment` : Permet de filtrer les coûts par environnement (Dev/Test/Prod).
*   `ManagedBy = "Terraform"` : Indique aux équipes qu'il est interdit de modifier cette ressource manuellement dans le portail Azure.
*   `Lab` : Permet d'identifier instantanément quelle leçon a créé cette ressource pour automatiser sa destruction sans risque.

---

## 🚦 Checklist de Revue du Plan avant Déploiement

Avant d'exécuter `terraform apply tfplan`, l'inspection humaine du plan doit valider ces 4 points :
1. [ ] **Ressource unique** : Uniquement `1 to add` (`azurerm_resource_group.lab`).
2. [ ] **Nomenclature exacte** : Le nom doit être strictement `clz-dev-clz140-rg`.
3. [ ] **Région cible** : Doit être `eastus2`.
4. [ ] **Métadonnées complètes** : Les 4 clés de tags (`Project`, `Environment`, `ManagedBy`, `Lab`) doivent être visibles et associées à leurs valeurs respectives.

---

## 🧹 Commande de Nettoyage Rapide
```powershell
terraform destroy -auto-approve