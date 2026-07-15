# 🛡️ Lab CLZ-210 : Sécurisation des accès d'administration via Azure Bastion

## 🎯 Objectif Claire
**Supprimer l'exposition directe du protocole RDP sur l'Internet public en convertissant la VM Windows en hôte 100% privé, tout en provisionnant une passerelle Azure Bastion managée pour sécuriser les flux d'administration directement depuis le navigateur.**

---

## 💡 Leçons Apprises & Fiche de Révision (Spécial Sécurité Réseau & Bastion)

### 1. Pourquoi utiliser Azure Bastion ?
*   **Protection contre le scan de ports** : Le port RDP `3389` n'est plus exposé sur internet.
*   **Connexion simplifiée** : L'accès se fait de manière transparente depuis le portail Azure, encapsulé dans du trafic HTTPS (Port `443`) sécurisé.
*   **Pas de clients lourds** : Aucun outil RDP local (comme MobaXterm ou mstsc) n'est nécessaire.

### 2. Les contraintes strictes d'Azure Bastion à retenir pour l'architecture :
1.  **Nom du sous-réseau** : Doit être obligatoirement et très exactement **`AzureBastionSubnet`**.
2.  **Taille du sous-réseau** : Minimum un masque `/26` (`/27` toléré dans certaines régions mais `/26` recommandé pour accueillir les instances de scaling).
3.  **Adresse IP Publique** : Doit obligatoirement être configurée avec un **SKU Standard** et une allocation **Statique**.

---

## 🚦 Procédure de Connexion & Validation

1.  Déployez le lab :
    ```powershell
    terraform init
    terraform apply -auto-approve
    ```
2.  Récupérez le mot de passe d'administration :
    ```powershell
    terraform output -raw windows_admin_password
    ```
3.  Connectez-vous au **Portail Azure** et cherchez votre VM : `clz-dev-clz210-private-web-winvm`.
4.  Cliquez sur **Connect** > **Connect via Bastion**.
5.  Saisissez l'identifiant `clzadmin` et collez le mot de passe récupéré à l'étape 2.
6.  *Votre session Windows Server s'ouvre directement au sein de votre navigateur !*

---

## 🧹 Commande de Nettoyage Rapide (🚨 À lancer rapidement pour le FinOps !)
```powershell
terraform destroy -auto-approve

## 🛠️  Compétences acquises avec ce chapitre

*   **Sécurisation d'Infrastructures IaaS (Zero-Trust) :** Suppression systématique des vecteurs d'attaque RDP/SSH publics au profit d'architectures réseau privées managées.
*   **Déploiement d'Azure Bastion :** Conception de la topologie de sous-réseaux dédiés (`AzureBastionSubnet`), d'adressages statiques Standard et provisionnement d'instances de bastion.
*   **Sécurité d'Accès d'Administration :** Intégration de flux d'administration sécurisés à authentification centralisée et masquage d'IP.