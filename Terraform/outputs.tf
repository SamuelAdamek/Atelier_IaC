# Outputs for the VM infrastructure

output "vm_ip_addresses" {
  description = "IP addresses of the created VMs"
  value       = [for vm in proxmox_vm_qemu.ubuntu_vm : vm.ipconfig0]
}

output "vm_names" {
  description = "Names of the created VMs"
  value       = proxmox_vm_qemu.ubuntu_vm[*].name
}

output "vm_ids" {
  description = "VM IDs"
  value       = proxmox_vm_qemu.ubuntu_vm[*].vmid
}
