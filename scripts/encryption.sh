#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT=$(git rev-parse --show-toplevel)
CONFIG_PATH="$PROJECT_ROOT/.sops.yaml"
SOPS_BIN="${PROJECT_ROOT}/.venv/bin/sops"

# Fallback if sops is available globally in PATH
command -v "$SOPS_BIN" >/dev/null 2>&1 || SOPS_BIN="sops"

encrypt_secret_file() {
    local file="$1"
    local sops_type="$2"

    local filename dir base ext target_file
    filename=$(basename "$file")
    dir=$(dirname "$file")
    base="${filename%.*}"
    ext="${filename##*.}"
    target_file="${dir}/${base}.sops.${ext}"

    # Catch empty files
    if [ ! -s "$file" ]; then
        echo "ERROR: File $filename is empty!" >&2
        exit 1
    fi

    echo "==> Encrypting: $file -> $(basename "$target_file") (Format: $sops_type)"

    "$SOPS_BIN" --encrypt \
        --config "$CONFIG_PATH" \
        --input-type "$sops_type" \
        --output-type "$sops_type" \
        --output "$target_file" \
        "$file"

    # Immediately remove plaintext source and stage the encrypted file
    rm -f "$file"
    git -C "$PROJECT_ROOT" add "$target_file"
    echo "    OK: Plaintext removed, $(basename "$target_file") staged."
}

# 1. OpenTofu (.tfvars -> dotenv format)
find "$PROJECT_ROOT/opentofu" -type f -name "*.tfvars" ! -name "*.sops.*" 2>/dev/null | while read -r f; do
    encrypt_secret_file "$f" "dotenv"
done

# 2. Tang Keys (.jwk -> json format)
find "$PROJECT_ROOT/ansible/roles/tang/files/tang-keys" -type f -name "*.jwk" ! -name "*.sops.*" 2>/dev/null | while read -r f; do
    encrypt_secret_file "$f" "json"
done

# 3. K8s Secrets (.yaml -> yaml format)
find "$PROJECT_ROOT/gitops" -type f -name "*.yaml" ! -name "*.sops.*" 2>/dev/null | while read -r f; do
    if grep -qE "^kind:\s*Secret" "$f"; then
        encrypt_secret_file "$f" "yaml"
    fi
done

echo ""
echo "Encryption completed. All secrets now follow the *.sops.* naming convention."
