variable "proxmox_api_url" {
  description = "URL de l'API Proxmox"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "ID du token API Proxmox"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Secret du token API Proxmox"
  type        = string
  sensitive   = true
}

variable "vm_count" {
  description = "Nombre de VMs à créer"
  type        = number
  default     = 2
}

variable "vm_names" {
  description = "Liste des noms des VMs"
  type        = list(string)
  default     = ["ubuntu-vm-db", "ubuntu-vm-bdd"] # Noms personnalisés
}

variable "vm_template" {
  description = "Nom du template Ubuntu Cloud-Init"
  type        = string
  default     = "ubuntu-noble-cloud-template" # Nom du template créé
}

variable "vm_cores" {
  description = "Nombre de cœurs CPU"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Mémoire RAM (en Mo)"
  type        = number
  default     = 2048
}

variable "vm_disk_size" {
  description = "Taille du disque (en Go)"
  type        = string
  default     = "20G"
}

variable "vm_network_bridge" {
  description = "Pont réseau Proxmox"
  type        = string
  default     = "vmbr0"
}

variable "vm_ip" {
  description = "Adresse IP de base (DHCP ou statique)"
  type        = string
  default     = "dhcp" # ou "192.168.1.100/24,gw=192.168.1.1"
}

variable "ssh_key" {
  type        = string
  description = "Contenu de la clé publique SSH"
  sensitive   = true
}
