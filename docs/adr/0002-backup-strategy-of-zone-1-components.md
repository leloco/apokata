# 0002-backup-strategy-of-zone-1-components

- **Status:** Accepted
- **Date:** 2026-08-07
- **Deciders:** leloco

## Context

Zone 1 (Mutable) components hold persistent configuration state, database records, and core infrastructure credentials. In the event of a disk failure, corruption, or disaster scenario, these services require a reliable multi-tiered backup strategy to ensure rapid recovery.

## Decision

Zone 1 core components will be backed up across two distinct locations based on operational scope:

1. **Proxmox Backup Server (PBS)**
   - Every Zone 1 component running as a LXC or VM is backed up via automated, incremental, and deduplicated full-guest snapshots.
   - Primary target for fast local state restoration and disaster recovery.

2. **Cloudflare R2 (Offsite S3 Storage)**
   - Every Zone 1 component with critical configuration files or databases (e.g., Keycloak, UniFi Controller, Nginx Proxy Manager) will have its exported state uploaded to Cloudflare R2.
   - Bare-metal appliances (e.g., OPNsense) will export encrypted configuration files directly to Cloudflare R2.
   - All files uploaded to R2 must be **locally encrypted** (e.g., via Age/GPG) prior to transfer.

## Consequences

- **Positive:**
  - Establishes a solid **3-2-1 backup strategy** for core infrastructure.
  - Fast local recovery via PBS for daily operational incidents without exhausting bandwidth.
  - Zero-cost, geo-redundant offsite backup via Cloudflare R2, protecting against local site disasters.
  - Strict local encryption ensures sensitive infrastructure configs remain private in Cloud-S3 storage.
- **Negative / Trade-offs:**
  - Requires maintaining automated local encryption pipelines (Ansible/Cron scripts) before offsite sync.
  - Standalone bare-metal services (OPNsense) cannot rely on PBS full-guest snapshots and must rely on config exports.
