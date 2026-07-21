# CLZ-250 : Déploiement de VM Windows Azure avec Terraform et for_each

## Objectif du projet

Ce projet Terraform met en place une infrastructure Azure basique pour des machines virtuelles Windows en utilisant `for_each` pour provisionner plusieurs ressources identiques avec des noms dynamiques.

Le but est d’illustrer :
- l’écriture de ressources réutilisables avec `for_each`,
- la gestion d’un réseau Azure simple avec groupe de ressources, VNet, sous-réseau et NSG,
- la création d’adresses IP publiques, d’interfaces réseau et de VM Windows à partir d’un seul bloc Terraform.

## Pourquoi ce projet existe

Il s’agit d’un laboratoire d’apprentissage pour comprendre le cycle Terraform sur Azure et le pattern de déploiement de ressources en série :

- éviter la duplication de code,
- garder des conventions de nommage cohérentes,
- maîtriser la création de plusieurs VM par itération sur une map.

## Ce que le projet déploie

Le projet crée les ressources suivantes :

1. `azurerm_resource_group` : groupe de ressources Azure.
2. `azurerm_virtual_network` : réseau virtuel (`10.40.0.0/16`).
3. `azurerm_subnet` : sous-réseau (`10.40.1.0/24`).
4. `azurerm_network_security_group` : groupe de sécurité réseau avec règle RDP.
5. `azurerm_public_ip` : adresse IP publique statique pour chaque VM.
6. `azurerm_network_interface` : interface réseau associée à chaque VM.
7. `azurerm_windows_virtual_machine` : VM Windows Server 2019 Datacenter.
8. `random_password` : mot de passe administrateur généré pour chaque VM.

## Organisation des fichiers

- `provider.tf` : configuration du fournisseur Azure.
- `resource-group.tf` : création du groupe de ressources.
- `locals.tf` : variables locales, préfixes et tags.
- `compute-for-each.tf` : réseau, NSG, IP publiques, NIC et VM avec `for_each`.
- `variables.tf` : variables d’entrée et valeurs par défaut.
- `outputs.tf` : sorties du déploiement.
- `terraform.tfvars.example` : exemple de valeurs à personnaliser.
- `versions.tf` : versions minimales de Terraform et providers.

## Variables importantes

- `subscription_id` : ID de l’abonnement Azure.
- `environment` : environnement (`dev`, `prod`, `staging`).
- `location` : région Azure.
- `name_prefix` : préfixe pour les noms de ressources.
- `admin_username` : nom d’utilisateur administrateur Windows.
- `admin_cidr` : CIDR autorisé pour l’accès RDP.
- `lab_id` : identifiant du lab.
- `vm_names` : map des VM à créer (par défaut `web` et `ops`).

## Bonnes pratiques

- Ne pas laisser `admin_cidr` sur `0.0.0.0/0` en environnement réel.
- Utiliser une adresse IP ou un bloc CIDR restreint pour l’accès RDP.
- Vérifier les règles de NSG avant d’appliquer le plan.

## Utilisation

1. Se connecter à Azure :
   ```powershell
   az login
   ```
2. Copier `terraform.tfvars.example` vers `terraform.tfvars` et personnaliser les valeurs.
3. Initialiser Terraform :
   ```powershell
   terraform init
   ```
4. Vérifier le plan :
   ```powershell
   terraform plan
   ```
5. Appliquer le déploiement :
   ```powershell
   terraform apply
   ```

## Sorties

- `resource_group_name` : nom du groupe de ressources.
- `windows_vm_public_ips` : adresses IP publiques des VM.
- `windows_admin_password` : mot de passe administrateur généré (sensible).

Pour afficher les IP publiques :
```powershell
terraform output windows_vm_public_ips
```

> Ce dépôt est un bon point de départ pour comprendre comment provisionner plusieurs ressources Azure de manière déclarative avec Terraform.


+----------------------------------+
                               |     var.vm_names (map)           |
                               |    web = "web", ops = "ops"      |
                               +----------------+-----------------+
                                                |
                      +-------------------------+-------------------------+
                      | (each.key = "web")                                | (each.key = "ops")
                      v                                                   v
+---------------------------------------------+   +---------------------------------------------+
| IP Publique : clz-dev-clz250-web-pip        |   | IP Publique : clz-dev-clz250-ops-pip        |
| Carte NIC   : clz-dev-clz250-web-nic        |   | Carte NIC   : clz-dev-clz250-ops-nic        |
| VM Windows  : clz-dev-clz250-web-winvm      |   | VM Windows  : clz-dev-clz250-ops-winvm      |
| ComputerName: clz250web                     |   | ComputerName: clz250ops                     |
+---------------------------------------------+   +---------------------------------------------+