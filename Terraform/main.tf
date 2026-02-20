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

  # Disques
  disk {
    slot    = "scsi0"
    storage = "local-lvm"
    type    = "disk"
    size    = "10G"
  }

  # Disque init cloud de ####### 
  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = "local-lvm"
  }

  # Réseau
  network {
	id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-Init
  # ipconfig0 = "ip=dhcp"
  ipconfig0 = "ip=192.168.107.20${count.index + 1}/24,gw=192.168.107.2"
  ciuser = "adminroot"
  cipassword = "adminroot"


# SSH - À AJOUTER
  sshkeys = <<EOF
${var.ssh_key}
EOF
}

