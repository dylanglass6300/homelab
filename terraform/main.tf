terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.1-rc1"
    }
    local = {
      source = "hashicorp/local"
      version = "2.5.1"
    }
  }
}

data "local_sensitive_file" "proxmox_token" {
  filename = "./token.txt"
}

provider "proxmox" {
  pm_api_url          = "http://10.0.0.225:8006/api2/json"
  pm_api_token_id     = "terraform@pve!terraform_api_token"
  pm_api_token_secret = data.local_sensitive_file.proxmox_token.content
  pm_tls_insecure     = true
  pm_log_enable       = true
  pm_log_file         = "terraform-plugin-proxmox.log"
  pm_debug            = true
}

resource "proxmox_vm_qemu" "kube-master" {
  name        = "kube-master"
  target_node = "pmox-1"
  iso         = "metal-amd64.iso"
}