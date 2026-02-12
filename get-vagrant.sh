#!/bin/bash
set -e

# Colors
GREEN='\033[1;32m'
RED='\033[1;31m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

INVENTORY_FILE="vagrant-inventory.ini"

echo -e "${CYAN}Ensuring VM is running...${NC}"
vagrant up

echo -e "${CYAN}Extracting SSH details from vagrant ssh-config...${NC}"

SSH_CONFIG=$(vagrant ssh-config)

HOST_IP=$(echo "$SSH_CONFIG" | awk '/HostName/ {print $2}')
PORT=$(echo "$SSH_CONFIG" | awk '/Port/ {print $2}')
KEY_FILE=$(echo "$SSH_CONFIG" | awk '/IdentityFile/ {print $2}')

chmod 600 "$KEY_FILE"

echo
echo -e "${CYAN}Creating ${INVENTORY_FILE}...${NC}"

cat > "${INVENTORY_FILE}" <<EOF
# AUTO-GENERATED FILE
# Safe to delete and regenerate

[vagrant]
vm ansible_host=${HOST_IP} ansible_port=${PORT} ansible_user=vagrant ansible_ssh_private_key_file=${KEY_FILE}

[vagrant:vars]
ansible_become=true
ansible_become_method=sudo
EOF

echo -e "${CYAN}${INVENTORY_FILE} created.${NC}"
echo

echo -e "${YELLOW}Copy & paste commands:${NC}"
echo
echo -e "${GREEN}ansible -i ${INVENTORY_FILE} vagrant -m ping${NC}"
echo
echo -e "${GREEN}ansible-playbook -i ${INVENTORY_FILE} main.yaml${NC}"
echo
echo -e "${GREEN}ssh -i ${KEY_FILE} -p ${PORT} vagrant@${HOST_IP}${NC}"
echo

echo -e "${CYAN}Running Ansible ping test...${NC}"
echo

if ansible -i "${INVENTORY_FILE}" vagrant -m ping; then
    echo
    echo -e "${GREEN}✔ Ansible connectivity successful.${NC}"
else
    echo
    echo -e "${RED}✖ Ansible connectivity failed.${NC}"
    echo "Check SSH connectivity or inventory configuration."
    exit 1
fi

echo
echo -e "${YELLOW}NOTE:${NC}"
echo "The 'vagrant' user has passwordless sudo (NOPASSWD)."
echo "No become password is required."
echo

