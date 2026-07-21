## Objectif du lab

Ce lab montre comment utiliser `count` dans Terraform pour créer plusieurs ressources identiques de manière simple et fiable.

- Il crée un petit ensemble de machines virtuelles Windows identiques.
- Chaque VM a ses propres ressources associées : IP publique, interface réseau (NIC), et la VM elle-même.
- Le nombre d’instances est contrôlé par `var.instance_count`, avec une valeur par défaut de `2`.
- Terraform produit alors des ressources indexées : `[0]`, `[1]`, etc.
- L’idée est de réduire les erreurs humaines liées à la copie manuelle : noms différents, paramètres oubliés, tags incohérents, mauvais sous-réseau, etc.

## Ce que tu dois apprendre

1. Comprendre le concept de `count`
   - `count` permet de déclarer un seul bloc de ressource et de le répliquer plusieurs fois.
   - Chaque instance est accessible par son index : `resource.example[count.index]`.

2. Connaître les variables Terraform
   - Ici `var.instance_count` contrôle le nombre de VM.
   - Apprendre à définir des variables dans `variables.tf` et à les passer dans `terraform.tfvars`.

3. Étudier les ressources répétées du lab
   - IP publique
   - Interface réseau (NIC)
   - Machine virtuelle Windows
   - Voir comment chacun de ces blocs utilise `count` et `count.index`.

4. Comprendre l’ordre de création
   - Les ressources dépendantes utilisent les instances précédentes via `count`.
   - Par exemple, le NIC référence l’IP publique indexée correspondante.

> En résumé : l’objectif est d’apprendre à créer plusieurs ressources identiques de façon déclarative avec `count`, en évitant les erreurs de duplication manuelle.

--------------------------------
# 🔢 Lab CLZ-240 : Count Windows VMs

## 🎯 Objectif Clair
**Industrialiser la création répétitive et homogène de ressources Azure (IPs publiques, cartes réseau et VMs Windows) en utilisant le méta-argument `count` de Terraform et l'accès par index numérique (`count.index`).**

---

## 💡 Leçons Apprises & Fiche de Révision (Méta-argument Count)

### 1. Le fonctionnement de `count` et `count.index`
*   **`count = N`** : Indique à Terraform de répéter la création d'un bloc de ressource $N$ fois.
*   **`count.index`** : Variable dynamique représentant l'index actuel (commence à `0`, puis `1`, `2`...).
*   **Ajustement visuel (`count.index + 1`)** : Utilisé dans les noms de ressources pour éviter d'avoir une VM "0" (`clz-dev-clz240-count-1-winvm`).

### 2. L'accès aux ressources indexées & Expressions Splat
*   **Référence croisée** : Pour lier la carte réseau 0 à l'IP 0, on écrit `azurerm_public_ip.web[count.index].id`.
*   **Splat Expression (`[*]`)** : Permet d'extraire la liste de toutes les valeurs d'un bloc répété sans faire de boucle, par exemple `azurerm_public_ip.web[*].ip_address`.

### 3. Quand utiliser `count` (et ses limites)
*   ✅ **Idéal pour** : Des ensembles de machines strictement identiques et interchangeables (pools de serveurs Web, agents de build).
*   ⚠️ **Attention** : La suppression de l'élément `[0]` entraîne la recréation de tous les éléments suivants car leurs index se décalent. Pour des ressources avec des rôles distincts, privilégier `for_each`.

---

## 🚦 Procédure de Validation du Lab

1. Déployez le projet :
   ```powershell
   terraform init
   terraform apply -auto-approve
   ```

## 📝 Évaluation du projet

### ✅ Complétude
Ce projet est globalement complet pour le lab `CLZ-240` :
- groupe de ressources,
- réseau et sous-réseau,
- IP publiques, NICs et VMs Windows créés avec `count`,
- outputs utiles comme les IP publiques.

### ⚠️ Points à améliorer
- `locals.tf` définit `local.prefix` et `compact_prefix` sans les utiliser dans les ressources.
- `variables.tf` contient `vm_names` et `region` qui ne sont pas utilisés actuellement.
- le déploiement est pédagogique, pas entièrement optimisé pour la production (pas de NSG, réseau plus flexible, etc.).

### 💡 Différence clé
Le projet met l’accent sur l’utilisation de `count` pour répéter des ressources identiques avec des indices numériques.
Pour des ressources différentes ou nommées, on utiliserait plutôt `for_each`, mais ici `count` est adapté à un ensemble homogène de VMs.
