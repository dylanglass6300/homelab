#!/bin/bash

apt update -y
apt upgrade -y
apt install git jq -y

cd /srv/ || return
git clone https://github.com/dylanglass6300/homelab.git /srv/homelab

pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
pveum user add terraform@pve
pveum aclmod / -user terraform@pve -role TerraformProv

cd /srv/homelab/terraform || return
token=$(pvesh create /access/users/terraform@pve/token/terraform_api_token -privsep false  | jq -r '.value')
echo "$token" >> token.txt

terraform init
terraform apply