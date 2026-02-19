resource "proxmox_vm_qemu" "ubuntu_vm" {
  count       = length(var.vm_names)
  name        = var.vm_names[count.index]
  target_node = "IaC"
  clone       = var.vm_template
  full_clone  = true

  # Configuration matérielle
  cores   = 1
  memory  = 1024
  scsihw  = "virtio-scsi-pci"

  # Disque (ajustez la taille si nécessaire)
  disk {
	slot    = "scsi0"      # Format: scsi0, scsi1, scsi2... ou ide0, ide1...
	size    = "10G"
	type    = "disk"
	storage = "local-lvm"
	format  = "qcow2"
}

  # Réseau
  network {
	id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-Init (IP dynamique ou statique)
  ipconfig0 = "ip=dhcp"
  # ipconfig0 = "ip=192.168.1.10${count.index + 1}/24,gw=192.168.1.1" # Exemple IP statique
}