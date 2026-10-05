# Proxmox NAS Storage Setup

This runbook outlines the steps taken to configure, troubleshoot, and automate the integration of TrueNAS SCALE storage (both NVMe-oF/TCP and NFS) into Proxmox VE nodes.

---

## 1. TrueNAS SCALE Side Configuration

### NFS Share Configuration
1. **Navigate to Shares > Unix (NFS Shares)** in the TrueNAS web interface.
2. Create or edit the dataset export path (e.g., `/mnt/bulk/proxmox/nfs`).
3. **Access Controls**:
   * Set the **Networks** restriction to match your storage/lab subnet (e.g., `10.0.99.0/24`).
   * Configure **Maproot User** and **Maproot Group** to `root` to prevent permission issues and allow Proxmox nodes full read/write capabilities without UID mismatching.

---

## 2. Proxmox VE Storage Configuration (`storage.cfg`)

Proxmox relies strictly on `/etc/pve/storage.cfg`. Correct formatting, block separation, and indentation are critical to prevent parsing errors and misplaced configurations.

This file content is automated via Ansible.

### Key Rules for `storage.cfg`:
* Every block type (e.g., `truenasplugin` or `nfs`) must start on a new line at the root level.
* **A clean, true empty line must separate distinct storage blocks** to prevent Proxmox from merging or misinterpreting properties.
* Indentation inside blocks must use consistent spacing (spaces, not tabs).

### Example Configuration Block
```text
truenasplugin: truenas-nvme
    content images,rootdir
    tn_api_host 10.0.99.8
    tn_api_key <YOUR_API_KEY>
    tn_dataset fast/proxmox/zvols
    tn_api_insecure 1
    shared 1
    tn_transport_mode nvme-tcp
    tn_discovery_portal 10.0.99.8:4420
    tn_subsystem_nqn nqn.2011-06.com.truenas:uuid:...:proxmox-nvme
    nodes ninja,primus

nfs: truenas-bulk-nfs
    path /mnt/pve/truenas-bulk-nfs
    server 10.0.99.8
    export /mnt/bulk/proxmox/nfs
    content vztmpl,backup,iso,rootdir
    options vers=3
    nodes ninja,primus
```

## 3. Checking Active Status

```
pvesm status
```



