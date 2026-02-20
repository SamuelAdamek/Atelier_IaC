proxmox_api_url         = "https://192.168.107.129:8006/api2/json"
proxmox_api_token_id    = "terraform@pve!terraform_token"
proxmox_api_token_secret = "e2d81d5e-ff4d-49a8-8548-eb10aa16231e"
vm_count                = 2
vm_template             = "ubuntu-noble-cloud-template" # Nom du template
vm_cores                = 2
vm_memory               = 2048
vm_disk_size            = "10G"
vm_network_bridge       = "vmbr0"
vm_ip                   = "dhcp"
vm_names = ["ubuntu-web-server", "ubuntu-db-server"] # Noms personnalisés
ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1XOM42UBNOMriu7vKeTjG9I+hymtJFl9vCujCX0PxNrzK0pVKuy4C1Mb1szwYVc7gSJZPk7DUmXzWKPuioSTO58A7mmMqfB91BnlnPDH8v8mhLFTZ4rAhC54geD5vn3gI/bAJxW5OhLm9v1d22dQMRb+hu7lgUneefJKoRAc/xQLAVdeMxHLFgWGKBVcCTUPFDPovgcUOErGG1Vt9B4xJGRrXIPo7vSFvH5b84QAjXrIV3xB/CXsVF055znLURewL+jViw1M7iR4z8Jv5tYNCbtTUnt1oPmnfohHvwUxWPTy0kRstYrezK09j+Bs7EogrMqesT3FSuPTZ182WxHLCAyNkJ4qlHkMs+t4Sfk7B4RUMiwjhxRVQbfw/BJzNGrZWCPFHE9jWdloFAUsleaapKoDkuYny026fdNkdFpyHW5J6I1z2RtA2S/x/fR+UJlEuJw8HVcrWbtngrCgBBixQRUezexcxaC/R9MpA28APrObsr0wMdHm5ranUqMYKyq921uqMzoa8XGF2xznlVhnB2IcWXkuPbvZWab9snNtX2La+LUJoWd0PmJFAC9uNvzfunyoJw9e0zfWdcheE/N7M+qhpX+e9jTczuv74GcffOl144TK3hM3Jce1CPQjr3LlUhRX/d6m+QSvnqwu4mK93Dr1bIL6qc03keh8YDcNkWQ== samueladamek@outlook.fr"
