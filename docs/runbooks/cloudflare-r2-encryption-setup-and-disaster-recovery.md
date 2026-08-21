# Cloudflare R2 Encryption Setup & Disaster Recovery

This runbook describes the key generation process with age to use it in an ansible playbook for disaster recovery decryption procedure for appliance backups stored in Cloudflare R2 with client-site encryption.

---

## Ansible Setup

1. One-Time Key Generation (Local)

Generate the asymmetric X25519 key pair on your local workstation (do not run this on the runner or server):

```bash
age-keygen
```

2. Store the secret key in your password manager only

3. Store the public key in Ansible Vault
   * Ansible is only capable of encrypting the content and uploading it not decrypting it


## Manual encryption


bash
```
age -r "<public-key>..." -o truenas_backup.tar.age truenas_backup.tar
```

## Disaster Recovery

### Scenario: TrueNAS Misconfiguration / Lost Pool Definition
A critical configuration error occurred on TrueNAS (e.g., a storage pool definition was deleted). Follow these steps to restore the system state from Cloudflare R2.

---

### Step 1: Download the Encrypted Backup Artifact
Download the latest verified backup from your Cloudflare R2 storage bucket using the AWS CLI or Cloudflare dashboard:

```bash
aws s3 cp s3://<your-bucket-name>/daily/truenas_backup_<YYYY-MM-DD>.tar.age ./truenas_backup.tar.age \
  --endpoint-url https://<ACCOUNT_ID>.r2.cloudflarestorage.com
```

---

### Step 2: Decrypt the Backup File
Retrieve the secret key (`AGE-SECRET-KEY-1...`) from your password manager. Decrypt the archive directly into a `.tar` file using process substitution so the private key is never written to disk:

```bash
age -d -i <(echo "AGE-SECRET-KEY-1...") -o truenas_backup.tar truenas_backup.tar.age
```

---

### Step 3: Restore Configuration in TrueNAS Web UI
1. Log in to the TrueNAS web interface.
2. Navigate to **System Settings** -> **General** -> **Manage Configuration**.
3. Click **Upload Config**.
4. Select the decrypted `truenas_backup.tar` archive and confirm the upload.
5. Allow the system to apply the database changes and reboot.
