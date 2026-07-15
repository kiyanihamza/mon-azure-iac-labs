# 🕸️ Lab CLZ-200 : Windows VM IIS Bootstrap

## 🎯 Objectif Claire
**Automatiser entièrement la configuration applicative interne du système d'exploitation Windows Server sans aucune action manuelle, en y provisionnant le service web IIS par le biais de l'extension Azure CustomScriptExtension.**

La philosophie de ce chapitre est de s'assurer que notre rôle serveur soit aussi reproductible et défini sous forme de code que l'infrastructure réseau qui l'héberge.

---

## 💡 Leçons Apprises & Fiche de Révision (Spécial Bootstrapping Cloud)

### 1. Qu'est-ce que la CustomScriptExtension (CSE) ?
C'est un agent Azure injecté dans l'OS invité après sa création qui exécute des commandes d'administration.
*   **Intérêt** : Évite d'avoir à gérer des protocoles de connexion complexes (comme WinRM ou Ansible) à travers des pare-feux pour configurer la machine après sa création.
*   **Ordre d'exécution** : Terraform attend que la VM soit créée, puis demande à l'API Azure d'injecter et de lancer le script.

### 2. Isolation & Dépendances Claires
*   **Dépendance explicite** : L'extension cible l'ID de la VM (`azurerm_windows_virtual_machine.web.id`). Terraform gère intelligemment la chronologie et n'essaiera jamais d'installer l'extension tant que la VM n'est pas "Prête".
*   **Sécurité** : L'accès HTTP (Port 80) est ouvert à tout le monde (`Internet`), mais le port d'administration RDP (`3389`) reste restreint à votre IP d'administration.

---

## 🚦 Procédure de Validation du Lab

Une fois le déploiement terminé, n'ouvrez pas de connexion RDP ! Validez le fonctionnement directement par le réseau depuis votre PC hôte :

1. Récupérez l'URL du serveur web :
   ```powershell
   $iisUrl = terraform output -raw iis_url
   
   pour récuperer les information d authentification
   $terraform output -raw windows_vm_public_ip
   $terraform output -raw windows_admin_password