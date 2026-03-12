🚀 Infrastructure Automatisée - Terraform & Ansible
Ce projet permet de déployer automatiquement une infrastructure complète composée de machines virtuelles sur Proxmox, configurées via Terraform et Ansible.

📋 Table des matières

Vue d'ensemble
Architecture
Prérequis
Structure du projet
Configuration
Utilisation
Détails des composants


🌐 Vue d'ensemble
Le projet automatise le déploiement de 3 VMs Ubuntu sur un hyperviseur Proxmox :
Copy table


VM
IP
Rôle



ubuntu-web-server (1)
192.168.1.221
Serveur Web (Nginx + PHP)


ubuntu-db-server
192.168.1.222
Serveur Base de données (PostgreSQL)


🏗 Architecture
<img width="832" height="507" alt="image" src="https://github.com/user-attachments/assets/7f8ea481-a770-446a-ac19-c4d800e6b6bf" />

Le script run_infrastructure.sh orchestre l'ensemble du processus :

Terraform provisionne les VMs sur Proxmox à partir d'un template Ubuntu Cloud-Init
Attente SSH : le script vérifie que les VMs sont accessibles
Ansible se connecte aux VMs et applique les configurations


✅ Prérequis
Logiciels requis

Terraform >= 1.0
Ansible >= 2.9
Un hyperviseur Proxmox VE accessible sur le réseau
Un template Ubuntu 24.04 Cloud-Init présent sur Proxmox
Une paire de clés SSH (~/.ssh/id_ed25519)

Accès réseau

Accès à l'API Proxmox (https://<proxmox-ip>:8006)
Token API Proxmox avec les droits nécessaires


📁 Structure du projet
.
├── run_infrastructure.sh        # Script principal de déploiement
│
├── Ansible/
│   ├── ansible.cfg              # Configuration Ansible
│   ├── site.yml                 # Playbook principal
│   ├── inventory/
│   │   ├── hosts.yml            # Inventaire des hôtes (YAML)
│   │   └── inventory.ini        # Inventaire des hôtes (INI)
│   ├── playbooks/
│   │   ├── common.yml           # Configuration commune (update, paquets)
│   │   ├── database.yml         # Installation PostgreSQL
│   │   └── webserver.yml        # Installation Nginx + PHP
│   └── templates/
│       ├── index.html.j2        # Template page web
│       └── nginx-default.conf.j2 # Template config Nginx
│
├── Terraform/
│   ├── main.tf                  # Ressources principales
│   ├── variables.tf             # Déclaration des variables
│   ├── terraform.tfvars         # Valeurs des variables
│   ├── outputs.tf               # Sorties Terraform
│   └── providers.tf             # Configuration du provider Proxmox
│
└── OLD/                         # Anciennes configurations (archives)

⚙️ Configuration
1. Terraform - terraform.tfvars
Modifiez le fichier Terraform/terraform.tfvars avec vos informations :
proxmox_api_url          = "https://<votre-proxmox-ip>:8006/api2/json"
proxmox_api_token_id     = "terraform@pve!terraformapi"
proxmox_api_token_secret = "<votre-secret>"

vm_names     = ["ubuntu-web-server", "ubuntu-db-server"]
vm_cores     = 2
vm_memory    = 2048
vm_disk_size = "10G"
vm_template  = "ubuntu-24.04-template"
ssh_key      = "~/.ssh/id_ed25519.pub"

⚠️ Ne commitez jamais votre terraform.tfvars contenant des secrets sur GitHub !Ajoutez-le à votre .gitignore.

2. Ansible - hosts.yml
L'inventaire est déjà configuré pour correspondre aux IPs définies dans Terraform :
webservers:
  hosts:
    192.168.1.221:
      ansible_user: adminroot
dbservers:
  hosts:
    192.168.1.222:
      ansible_user: adminroot
3. Token API Proxmox
Créez un token API sur Proxmox avec les permissions suivantes :

VM.Allocate, VM.Clone, VM.Config.*
Datastore.AllocateSpace, Datastore.Audit
Pool.Allocate, Sys.Audit


🚀 Utilisation
Déploiement complet (recommandé)
# Cloner le dépôt
git clone <url-du-repo>
cd <nom-du-repo>

# Rendre le script exécutable
chmod +x run_infrastructure.sh

# Lancer le déploiement complet
./run_infrastructure.sh
Le script effectue automatiquement :

terraform init (si nécessaire)
terraform plan + terraform apply
Attente de disponibilité SSH des VMs
ansible-playbook site.yml

Déploiement manuel étape par étape
# --- Terraform ---
cd Terraform/
terraform init
terraform plan -out=tfplan
terraform apply tfplan

# --- Ansible ---
cd ../Ansible/
ansible-playbook site.yml -i ../hosts.yml -v
Destruction de l'infrastructure
cd Terraform/
terraform destroy

🔧 Détails des composants
Ansible Playbooks
common.yml - Configuration commune
Appliqué sur toutes les VMs :

Mise à jour des paquets (apt update && apt upgrade)
Installation des outils de base : curl, wget, git, vim, unzip
Création du groupe admin et ajout de l'utilisateur adminroot

webserver.yml - Serveur Web
Appliqué sur les webservers (192.168.1.221 & 192.168.1.223) :

Installation de Nginx + nginx-extras
Installation de PHP 8.3 et extensions (php-fpm, php-mysql, php-curl, php-gd, etc.)
Configuration de PHP-FPM (www.conf)
Déploiement d'une page index.html personnalisée via template Jinja2
Configuration du virtual host Nginx

database.yml - Serveur Base de données
Appliqué sur les dbservers (192.168.1.222) :

Installation de PostgreSQL 16 + postgresql-contrib
Création de la base de données myapp
Création de l'utilisateur dbuser
Configuration de l'authentification md5 dans pg_hba.conf
Écoute sur toutes les interfaces (listen_addresses = '*')

Terraform - Ressources
Chaque VM est créée avec :

CPU : 2 cœurs
RAM : 2048 Mo
Disque : 10 Go (virtio-scsi)
Réseau : Bridge vmbr0 avec IP statique
Cloud-Init : Utilisateur adminroot, clé SSH injectée


🔒 Sécurité

Les éléments suivants ne doivent pas être committés :

# Secrets Terraform
Terraform/terraform.tfvars
Terraform/*.tfstate
Terraform/*.tfstate.backup
Terraform/.terraform/
Terraform/tfplan

# Clés SSH
*.pem
*.key

📝 Notes

Le template Proxmox ubuntu-24.04-template doit être créé manuellement au préalable avec Cloud-Init activé.
Les IPs sont assignées de façon statique : 192.168.1.22X où X correspond à l'index de la VM.
Le dossier OLD/ contient d'anciennes configurations HyperV conservées à titre d'archive.
