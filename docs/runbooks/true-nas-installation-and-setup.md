# TrueNAS Initial Setup

- **Author:** leloco
- **Created at:** 2026-08-20

## Prerequisites

- Installation completed (Bare-Metal)
- Access to the WebUI

## General

1. Change timezone to UTC (**System Settings** -> **General** -> **Localization**).
2. Update `truenas_admin` password (**Credentials** -> **Local Users**).

- [x] Initialized on 08/20/2026

## Network Configuration (Management Network)

1. Navigate to **Network** -> **Interfaces**.
2. Edit the primary physical interface (`NIC 1`).
3. Uncheck **DHCP**.
4. Set static **IP Address** (ipv4 and ipv6) and **Subnet Mask**
5. Set **Default Gateway** and **DNS Nameservers** under **Global Configuration**.
6. Click **Apply Changes** and verify WebUI access.

- [x] Initialized on 08/20/2026

## Dedicated Storage Network (Non-Routable)

1. Navigate to **Network** -> **Interfaces**.
2. Edit the secondary physical interface (`NIC 2`).
3. Set **IP Address** to `10.0.99.3/29`.
4. Set **MTU** to `9000` (Enables Jumbo Frames for lower CPU overhead during heavy NFS traffic; requires end-to-end support across all nodes and the intermediate switch).
5. Leave **Gateway** empty.
6. Click **Apply Changes**.

- [x] Initialized on 08/20/2026

## Storage Pools & Datasets

### Pool 1: `fast` (SSDs)

1. Navigate to **Storage** -> **Create Pool**.
2. Name: `fast`
3. Layout: **Mirror** (Select both NVMe/SSDs).
4. Create Dataset:
   - Path: `fast/k8s`
   - Advanced Options: Set **Sync** to **Disabled** (optimizes write IOPS on consumer SSDs without dedicated PLP/SLOG).

### Pool 2: `bulk` (HDDs)

1. Navigate to **Storage** -> **Create Pool**.
2. Name: `bulk`
3. Layout: **Mirror** (Select both HDDs).
4. Create Dataset:
   - Path: `bulk/k8s`
   - Advanced Options: Set **Sync** to **Standard** (optional: set `recordsize=1M` for large media files/backups).

- [x] Initialized on 08/20/2026

## Shares & Protocols (NFS for Kubernetes)

1. **Enable Service:** Navigate to **System Settings** -> **Services** -> Enable **NFS** and toggle **Start Automatically**.
2. **Configure Shares:** Navigate to **Shares** -> **Unix Shares (NFS)** -> **Add**:
   - **Path:** `/mnt/fast/k8s` (and repeat for `/mnt/bulk/k8s`)
   - **Networks:** `10.0.99.0/29`
   - **Advanced Options:** Set **Maproot User** to `root` and **Maproot Group** to `root`

- [ ] Initialized on

## Maintenance & Data Protection

- **SSH Access:**
  - Navigate to **System Settings** -> **Services** -> Configure and enable **SSH**.
  - Add public SSH keys under **Credentials** -> **Local Users** (`truenas_admin`).
- **Disk Health & Integrity:**
  - **Scrub Tasks:** Set monthly pool scrubs under **Data Protection** -> **Scrub Tasks**.
  - **S.M.A.R.T. Tasks:** Schedule weekly disk self-tests under **Data Protection** -> **S.M.A.R.T. Tasks**.
- **Automated Configuration Backup:**
  - **Best Option (TrueNAS Built-in):** Navigate to **Data Protection** -> **Cloud Sync Tasks** -> Export `/data/freenas-v1.db` to remote Cloudflare R2 storage.

- [ ] Initialized on
