# 🖥️ Lab CLZ-190 : Déploiement de Machine Virtuelle Windows Server

## 🎯 Objectif Claire
**Automatiser le déploiement sécurisé d'un serveur Windows Server en encapsulant le réseau, l'interface réseau (NIC), l'adressage IP public, ainsi que la génération cryptographique d'identifiants d'administration.**

Ce lab met en pratique l'assemblage complet d'une ressource de calcul (Compute) au sein de la topologie réseau et de sécurité construite dans les chapitres précédents.

---

## 💡 Leçons Apprises & Fiche de Révision (Spécial Virtualisation Cloud)

### 1. Gestion sécurisée des Secrets (Sensitive Outputs)
Stocker un mot de passe administrateur en clair dans le code (`.tf`) ou dans un fichier de variables (`.tfvars`) est une faute grave de sécurité. 
*   **La solution IaC** : Nous utilisons le provider `random` via la ressource `random_password` pour générer un mot de passe complexe de 20 caractères lors du déploiement.
*   **Masquage des données** : En déclarant l'output comme `sensitive = true`, Terraform bloque son affichage accidentel lors des commandes de plan ou d'apply.

> 🛠️ **Comment récupérer le mot de passe généré localement ?**
> Pour obtenir le mot de passe d'administration et vous connecter en RDP, exécutez la commande :
> ```powershell
> terraform output -raw windows_admin_password
> ```
> *Note : Cette valeur doit rester confidentielle et ne jamais être committée sur GitHub.*

### 2. Chaînage des dépendances
La création d'une VM nécessite que de nombreuses ressources préalables soient opérationnelles. Terraform résout ces dépendances implicitement via les références de variables :
1. **IP Publique** + **Sous-réseau** ➡️ Requis par la **NIC** (Interface Réseau).
2. **NIC** + **Password** ➡️ Requis par la **Virtual Machine**.

---

## 🚦 Checklist de Revue de Plan (Avant Déploiement)

- [ ] **Taille de la VM** : Configurée en `Standard_B2s` (économique et idéal pour les labs).
- [ ] **Système d'exploitation** : Image `2022-datacenter-azure-edition`.
- [ ] **Sécurisation RDP** : La règle d'accès distant port `3389` reste bridée sur votre IP publique (`admin_cidr`).

---

## 🧹 Commande de Nettoyage Rapide
```powershell
terraform destroy -auto-approve