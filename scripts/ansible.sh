#!/usr/bin/env bash
set -euo pipefail


# Navigate to project root
cd "$(dirname "$0")/../ansible"

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

# Activate virtual environment
echo "==> Activating virtual environment..."
source .venv/bin/activate

# Upgrade pip and install Python dependencies
echo "==> Installing Python requirements..."
pip install --upgrade pip
pip install -r requirements.txt

# Install Ansible collections locally into the project path
echo "==> Installing Ansible collections..."
ansible-galaxy collection install -r requirements.yml

echo "==> Ansible environment is ready!"
