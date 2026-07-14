# 🛡️ Lab CLZ-180 : Sécurisation Périmétrique (Network Security Groups & Rules)

## 🎯 Objectif Clair
**Sécuriser et contrôler de manière granulaire les flux réseaux entrants (Inbound) sur un sous-réseau spécifique à l'aide de Network Security Groups (NSG) déclarés en tant que code.**

Ce lab démontre comment appliquer des politiques de sécurité strictes et auditables. Plutôt que de s'en remettre à la configuration manuelle et mémorielle de pare-feu, les flux autorisés sont documentés, priorisés et associés par Terraform de façon déterministe.

---

## 🔒 Détails des Règles de Sécurité Implémentées

Dans ce lab, nous protégeons uniquement le sous-réseau **`web-snet`** en limitant l'exposition aux ports strictement nécessaires :

| Règle (Nom) | Priorité | Direction | Action | Protocole | Port Dest. | Source Autorisée | Justification |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`allow-http`** | `100` | Inbound | **Allow** | TCP | `80` | `Internet` | Trafic web public standard. |
| **`allow-admin-rdp`** | `110` | Inbound | **Allow** | TCP | `3389` | `var.admin_cidr` | Accès administratif restreint (Pas d'exposition publique). |

---

## 💡 Leçons Apprises & Fiche de Révision (Spécial Sécurité)

### 1. Le principe du moindre privilège (Least Privilege)
La règle d'or de la sécurité cloud est de ne jamais exposer un port d'administration (comme le port RDP `3389` ou SSH `22`) à l'ensemble d'Internet (`*` ou `0.0.0.0/0`). 
*   **La Pratique** : Nous avons utilisé une variable d'entrée spécifique `admin_cidr` (ex: `203.0.113.10/32`) pour que seul l'administrateur légitime puisse tenter une connexion.

### 2. Séparation de la Règle et de son Association
Créer un NSG et des règles sur Azure ne protège rien par défaut. La sécurité devient effective uniquement à l'étape d'association :
```hcl
resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
}