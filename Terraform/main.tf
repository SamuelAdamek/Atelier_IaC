resource "proxmox_vm_qemu" "ubuntu_vm" {
  count       = length(var.vm_names)
  name        = var.vm_names[count.index]
  target_node = "pve"
  clone       = var.vm_template
  full_clone  = true
  vmid 	      = "1100${count.index + 1}"
  agent       = 1

  # Configuration matérielle
  cores   = 1
  memory  = 1024
  scsihw  = "virtio-scsi-pci"

  # Disques
  disk {
    slot    = "scsi0"
    storage = "school-work"
    type    = "disk"
    size    = "10G"
  }

  # Disque init cloud de ####### 
  disk {
    slot    = "ide2"
    type    = "cloudinit"
    storage = "school-work"
  }

  # Réseau
  network {
	id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Cloud-Init
  # ipconfig0 = "ip=dhcp"
  ipconfig0 = "ip=192.168.1.22${count.index + 1}/24,gw=192.168.1.1"
  ciuser = "adminroot"
  cipassword = "adminroot"


# SSH 
  sshkeys = file(var.ssh_key)
}

