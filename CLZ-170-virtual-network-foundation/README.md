# 🌐 Lab CLZ-170 : Fondation Réseau (Virtual Network & Subnets)

## 🎯 Objectif Clair
**Concevoir et déployer une topologie réseau Azure segmentée en couches (N-Tier) hautement sécurisée, en garantissant l'absence de chevauchements d'adresses IP grâce à l'IaC.**

Ce lab marque la transition vers des architectures multi-ressources connectées. L'objectif est d'implémenter un réseau virtuel (VNet) et quatre sous-réseaux (Subnets) dédiés, prêts à accueillir des politiques de sécurité réseau (NSG) strictes.

---

## 📝 Résumé de la Topologie Déployée

Nous avons créé un réseau segmenté basé sur la plage d'adresses globale **`10.40.0.0/16`** :

---

## 💡 Leçons Apprises & Fiche de Révision (Spécial Réseau Cloud)

### 1. Pourquoi la segmentation réseau est-elle cruciale ?
La création de sous-réseaux isolés (`web`, `app`, `data`) permet d'appliquer le principe du **moindre privilège**. Bien que tous les sous-réseaux résident au sein du même VNet parent, cette isolation logique permet de restreindre plus tard le trafic (ex: interdire au sous-réseau `web` de parler directement au sous-réseau `data` sans passer par la couche `app`).

### 2. Référencement implicite vs Valeurs codées en dur (Hardcoded)
Dans le fichier `network.tf`, observez comment le VNet et les sous-réseaux héritent dynamiquement de la région et du groupe de ressources :
```hcl
location            = azurerm_resource_group.lab.location
resource_group_name = azurerm_resource_group.lab.name