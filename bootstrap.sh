#!/bin/bash
set -e

# Colors
CYAN='\033[1;36m'
GREEN='\033[1;32m'
NC='\033[0m'

INVENTORY_FILE="vagrant-inventory.ini"

# Optional: first argument is the local user, default to "vagrant"
LOCAL_USER_OVERRIDE="${1:-vagrant}"

echo -e "${CYAN}Extracting SSH details from vagrant ssh-config...${NC}"

SSH_CONFIG=$(vagrant ssh-config)

HOST_IP=$(echo "$SSH_CONFIG" | awk '/HostName/ {print $2}')
PORT=$(echo "$SSH_CONFIG" | awk '/Port/ {print $2}')
KEY_FILE=$(echo "$SSH_CONFIG" | awk '/IdentityFile/ {print $2}')

chmod 600 "$KEY_FILE"

echo
echo -e "${CYAN}Creating ${INVENTORY_FILE}...${NC}"

cat >"${INVENTORY_FILE}" <<EOF
# AUTO-GENERATED FILE
# Safe to delete and regenerate

[vagrant]
vm ansible_host=${HOST_IP} ansible_port=${PORT} ansible_user=vagrant ansible_ssh_private_key_file=${KEY_FILE}

[vagrant:vars]
ansible_become=true
ansible_become_method=sudo
local_user=${LOCAL_USER_OVERRIDE}
EOF

echo -e "${GREEN}${INVENTORY_FILE} created successfully.${NC}"
