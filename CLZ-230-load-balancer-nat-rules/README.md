# ⚖️ Lab CLZ-230 : Load Balancer NAT Rules

## 📌 Description du répertoire
Ce dépôt contient une configuration Terraform pour déployer un laboratoire Azure.
Il crée un groupe de ressources, un réseau virtuel, un sous-réseau, un Load Balancer Standard, deux machines virtuelles Windows et des règles réseau.
Le lab montre comment exposer un service web sur le port `80` et sécuriser l'accès RDP via une règle NAT entrante qui redirige le port externe `50001` vers le port interne `3389` d'une VM.

## 🎯 Objectif Clair
**Sécuriser l'accès d'administration RDP d'un pool de machines virtuelles privées en utilisant une règle de redirection NAT (Inbound NAT Rule) sur un Azure Standard Load Balancer unique. Le trafic d'administration externe (port 50001) est redirigé vers le port d'écoute interne de la première machine virtuelle (port 3389).**

---

## 💡 Leçons Apprises & Fiche de Révision (Inbound NAT Rules)

### 1. Différence fondamentale entre Load Balancing Rule et Inbound NAT Rule
*   **Load Balancing Rule :** Distribue le trafic d'entrée (ex: port 80) de manière transparente sur **l'ensemble** des serveurs du Backend Address Pool.
*   **Inbound NAT Rule :** Établit une liaison statique **1:1** entre un port externe spécifique du Load Balancer (ex: port 50001) et une carte réseau privée (NIC) spécifique d'une seule machine virtuelle pour un protocole d'administration.

### 2. Le rôle du NSG (Network Security Group)
Même si le Load Balancer redirige le port `50001` vers le port `3389`, le pare-feu réseau (NSG) d'Azure traite le paquet **après** la traduction d'adresse. 
*   La règle de sécurité de votre NSG doit autoriser le trafic de destination sur le port **`3389`** (RDP), et non pas sur le port externe `50001`.
*   C'est une excellente pratique de restreindre le `source_address_prefix` à votre adresse IP publique d'administration uniquement (`admin_cidr`).

---

## 🚦 Procédure de Validation du Lab

1. Déployez le projet :
   ```powershell
   terraform init
   terraform apply -auto-approve