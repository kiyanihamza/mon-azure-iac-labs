# 🔄 Lab CLZ-150 : Le Modèle de Données (Variables, Locals, Outputs)

## 🎯 Objectif Clair
**Séparer de manière étanche les données d'entrée (Inputs), la logique de transformation (Calculated), les résultats de déploiement (Outputs) et les fichiers de configuration partagés.**

Ce lab met fin aux mauvaises pratiques où les valeurs sont codées "en dur" à l'intérieur des ressources Azure. En attribuant un rôle précis à chaque type de donnée, le code devient hautement réutilisable pour des architectures complexes (réseaux, compute, monitoring).

---

## 📝 Résumé du Lab
Nous avons déployé le groupe de ressources standard `clz-dev-clz150-rg` dans la région `eastus2`. L'accent a été mis sur le flux d'exécution de la donnée :
1. Les paramètres bruts sont capturés par les **Variables**.
2. Ces paramètres sont nettoyés et assemblés de manière dynamique par les **Locals**.
3. La ressource Azure consomme ces valeurs pré-calculées.
4. Les données concrètes issues d'Azure après création sont lues et renvoyées par les **Outputs**.

---

## 💡 Leçons Apprises & Fiche de Révision (DevOps Mindset)

### 1. La règle d'or du "Chacun son job"
Pour écrire du code propre et maintenable, la règle d'attribution d'une valeur est simple :
*   **Une valeur doit pouvoir changer selon l'environnement ?** ➡️ Elle va dans une `variable`.
*   **Une valeur est le résultat d'un calcul ou d'une combinaison ?** ➡️ Elle va dans un `local`.
*   **Une valeur est générée ou confirmée par Azure après le déploiement ?** ➡️ Elle va dans un `output`.

### 2. Le pare-feu entre modèle partagé et variables locales
*   **`terraform.tfvars.example`** : C'est le plan de configuration de référence. Il est commité sur GitHub car il montre la *forme* attendue des données (ex: type d'instance, CIDR, etc.) sans contenir de données privées.
*   **`terraform.tfvars` (Local)** : C'est votre configuration personnelle sur votre machine de travail. Elle contient vos vrais identifiants de souscription ou configurations spécifiques. **Ce fichier doit être banni des commits Git via le `.gitignore`**.

### 3. Pourquoi les Outputs sont essentiels en production ?
Les outputs ne servent pas uniquement à faire de l'affichage joli dans la console. Ils transforment des données réelles d'infrastructure en variables d'entrée exploitables par d'autres configurations ou d'autres équipes (ex: transmettre l'ID d'un réseau à une équipe qui déploie des machines virtuelles).

---

## 🚦 Schéma de Validation du Flux (Plan Review)

Pendant l'exécution de `terraform plan -out tfplan`, vous devez être capable de tracer visuellement le cheminement de la donnée :