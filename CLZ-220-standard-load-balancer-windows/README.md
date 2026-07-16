  
  
  
  # ⚖️ Lab CLZ-220 : Standard Load Balancer Windows

## 🎯 Objectif Claire
**Déployer une architecture haute disponibilité à l'aide d'un Azure Standard Load Balancer pour distribuer uniformément le trafic web entrant (port 80) sur deux serveurs Windows IIS d'arrière-plan sans adresses IP publiques.**

---

## 💡 Leçons Apprises & Fiche de Révision (Spécial Load Balancing)

### 1. Les Composants Clés d'un Azure Load Balancer (ALB)
Pour qu'un Load Balancer fonctionne, vous devez impérativement configurer ces 4 éléments dans Terraform :
1.  **Frontend IP Configuration** : L'adresse IP publique d'entrée (le guichet unique) sur lequel les clients se connectent.
2.  **Backend Address Pool** : Le groupe logique contenant les machines prêtes à recevoir le trafic.
3.  **Health Probe (Sonde de santé)** : Le test régulier (ici un ping TCP sur le port 80) pour vérifier si les serveurs d'arrière-plan sont en vie. Si une machine ne répond plus, ALB l'isole automatiquement.
4.  **Load Balancing Rule (La Règle)** : Le contrat. "Tout trafic arrivant sur le port HTTP 80 du Frontend est envoyé sur le port HTTP 80 du Backend Pool à condition que la Health Probe soit valide."

### 2. Le piège classique : L'Association de Carte Réseau (NIC)
Avoir des machines virtuelles et un Load Balancer ne suffit pas ! Il faut lier les deux. 
C'est le rôle de la ressource :
`azurerm_network_interface_backend_address_pool_association`.
C'est elle qui injecte la carte réseau privée de chaque VM à l'intérieur du pool d'écoute du répartiteur.

---

## 🚦 Procédure de Validation du Lab

1. Déployez le projet :
   ```powershell
   terraform init
   terraform apply -auto-approve
  



*   **Haute Disponibilité (High Availability) :** Conception d'architectures résilientes à répartition de charge avec l'implémentation de serveurs web redondés.
*   **Load Balancing Azure Standard :** Gestion complète de la configuration d'Azure Load Balancer (Frontend IPs, Backend Pools, Sondes de santé TCP/HTTP et règles de routage).
*   **Gestion des ressources dynamiques (Count Meta-Argument) :** Industrialisation de l'infrastructure via Terraform pour provisionner simultanément plusieurs hôtes de calcul et extensions logicielles identiques.
  
  ### En résumé, ce qu'il faut mémoriser pour un entretien technique ou pour votre quotidien d'ingénieur DevOps :
* Un Load Balancer ne distribue pas vers des "VMs", il distribue vers des **IPs de cartes réseaux (NICs)**.
* Il a besoin d'une **Sonde (Probe)** pour savoir si les serveurs derrière sont en bonne santé avant de leur envoyer des utilisateurs.
* Dans Terraform, l'attachement d'une VM au Load Balancer se fait via une **ressource d'association explicite**, et non pas directement dans les propriétés de la VM.
  
  
                        [ UTILISATEURS SUR INTERNET ]
                                  |
                                  | (Requête HTTP - Port 80)
                                  v
                +------------------------------------+
                |  IP PUBLIQUE DU LOAD BALANCER      |
                |     (clz-dev-clz220-lb-pip)        |
                +-----------------+------------------+
                                  |
                                  v
                +------------------------------------+
                |      STANDARD LOAD BALANCER        |
                |       (clz-dev-clz220-web-lb)      |
                +-----------------+------------------+
                                  |
            +---------------------+---------------------+
            | (Vérifie la santé via la sonde TCP 80)     |
            |                                           |
            v                                           v
+=======================+                   +=======================+
|     VM BACKEND 1      |                   |     VM BACKEND 2      |
| clz-dev-clz220-web-1  |                   | clz-dev-clz220-web-2  |
|   (Répond: Backend 1) |                   |   (Répond: Backend 2) |
+=======================+                   +=======================+

