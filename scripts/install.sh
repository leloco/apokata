#!/usr/bin/env bash
set -euo pipefail

detect_os_arch() {
    OS=$(uname -s | tr '[:upper:]' '[:lower:]')
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64) ARCH="amd64" ;;
        aarch64|arm64) ARCH="arm64" ;;
    esac
}

# Navigate to project root
PROJECT_ROOT=$(git rev-parse --show-toplevel)
cd "$PROJECT_ROOT"

echo $PROJECT_ROOT

VENV_DIR=".venv"
VENV_BIN_DIR="${VENV_DIR}/bin"
SOPS_VERSION="v3.9.0"
TOFU_VERSION="v1.10.7"

echo "=================================================="
echo " Setting up unified development & GitOps environment"
echo "=================================================="

# Create the unified Python virtual environment at the repository root
if [ ! -d "$VENV_DIR" ]; then
    echo "==> Creating Python virtual environment in ${VENV_DIR}..."
    python3 -m venv "$VENV_DIR"
fi

# Activate virtual environment
echo "==> Activating virtual environment..."
source "${VENV_BIN_DIR}/activate"

# sets $OS and $ARCH
detect_os_arch

# Upgrade pip and install Python dependencies (Ansible, pre-commit, etc.)
echo "==> Installing Python requirements..."
pip install --upgrade pip
if [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
else
    echo "WARNING: requirements.txt not found at root."
fi

# Install Ansible collections if requirements.yml exists
if [ -f "requirements.yml" ]; then
    echo "==> Installing Ansible collections..."
    ansible-galaxy collection install -r requirements.yml
fi

# Download SOPS directly into the virtual environment bin folder
if [ ! -f "${VENV_BIN_DIR}/sops" ]; then
    echo "==> Downloading SOPS ${SOPS_VERSION}..."
    # Download binary and make it executable
    DOWNLOAD_URL="https://github.com/getsops/sops/releases/download/${SOPS_VERSION}/sops-${SOPS_VERSION}.${OS}.${ARCH}"
    curl -sL --fail "$DOWNLOAD_URL" -o "${VENV_BIN_DIR}/sops"
    chmod +x "${VENV_BIN_DIR}/sops"
    echo "==> SOPS successfully installed in ${VENV_BIN_DIR}!"
else
    echo "==> SOPS is already installed in ${VENV_DIR}."
fi

# Install opentofu binary
if [ ! -f "${VENV_BIN_DIR}/tofu" ]; then
    echo "==> Downloading OpenTofu ${TOFU_VERSION}..."
    TOFU_CLEAN_VERSION="${TOFU_VERSION#v}"
    # Download tar.gz and extract only the 'tofu' binary directly into VENV_BIN_DIR
    DOWNLOAD_URL="https://github.com/opentofu/opentofu/releases/download/v${TOFU_CLEAN_VERSION}/tofu_${TOFU_CLEAN_VERSION}_${OS}_${ARCH}.tar.gz"
    curl -sL --fail "$DOWNLOAD_URL" | tar -xz -C "${VENV_BIN_DIR}" tofu
    chmod +x "${VENV_BIN_DIR}/tofu"
    echo "==> OpenTofu successfully installed in ${VENV_BIN_DIR}!"
else
    echo "==> OpenTofu is already installed in ${VENV_BIN_DIR}."
fi

# Initialize and install pre-commit git hooks
if command -v pre-commit &> /dev/null; then
    echo "==> Installing pre-commit git hooks..."
    pre-commit install
else
    echo "WARNING: pre-commit is not available in the virtual environment."
fi

echo ""
echo "=================================================="
echo " Environment setup is complete! 🚀"
echo " To start working, run: source ${VENV_DIR}/bin/activate"
echo "=================================================="


