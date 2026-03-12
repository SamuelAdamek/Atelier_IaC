#!/bin/bash
#===============================================================================
# Infrastructure Deployment Script
# This script runs Terraform to create VMs and then configures them with Ansible
# 
# Usage: ./run_infrastructure.sh
#===============================================================================

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${YELLOW}========================================${NC}"
echo -e "${YELLOW}  Infrastructure Deployment Script${NC}"
echo -e "${YELLOW}========================================${NC}"
echo ""

#-------------------------------------------------------------------------------
# Step 1: Run Terraform
#-------------------------------------------------------------------------------
echo -e "${GREEN}[1/3] Running Terraform...${NC}"
echo "-------------------------------------------"

cd "$SCRIPT_DIR/Terraform"

# Initialize Terraform if needed
if [ ! -d ".terraform" ]; then
    echo "Initializing Terraform..."
    terraform init
fi

# Plan and apply
echo "Creating infrastructure..."
terraform plan -out=tfplan
terraform apply tfplan

echo -e "${GREEN}Terraform completed successfully!${NC}"
echo ""

#-------------------------------------------------------------------------------
# Step 2: Wait for VMs to be ready
#-------------------------------------------------------------------------------
echo -e "${GREEN}[2/3] Waiting for VMs to be ready...${NC}"
echo "-------------------------------------------"

# Wait for SSH to be available on all VMs
VM_IPS=("192.168.1.221" "192.168.1.222")

for ip in "${VM_IPS[@]}"; do
    echo -n "Waiting for $ip..."
    max_attempts=30
    attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o BatchMode=yes adminroot@$ip "exit 0" 2>/dev/null; then
            echo -e " ${GREEN}OK${NC}"
            break
        fi
        attempt=$((attempt + 1))
        sleep 10
    done
    
    if [ $attempt -eq $max_attempts ]; then
        echo -e " ${RED}FAILED${NC}"
        echo -e "${RED}VM at $ip is not reachable. Continuing anyway...${NC}"
    fi
done

echo ""

#-------------------------------------------------------------------------------
# Step 3: Run Ansible
#-------------------------------------------------------------------------------
echo -e "${GREEN}[3/3] Running Ansible...${NC}"
echo "-------------------------------------------"

cd "$SCRIPT_DIR/Ansible"

# Set environment variable for safety
export ANSIBLE_HOST_KEY_CHECKING=False

# Run Ansible playbook
ansible-playbook site.yml -i inventory.ini -v

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Deployment Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "VM Information:"
echo "  - Web Server:   http://192.168.1.221"
echo "  - Database:     192.168.1.222:5432"
echo ""

