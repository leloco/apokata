# Runbook: Proxmox QDevice Setup

## 1. Concept
A QDevice (Raspberry Pi) acts as a 3rd tie-breaker vote in a 2-node cluster to prevent split-brain and maintain quorum during node failures.

## 2. Prerequisites (via Ansible)
- **Proxmox nodes:** `corosync-qdevice` installed.
- **Raspberry Pi:** `corosync-qnetd` installed and running.
- **Raspberry Pi:** SSH `PermitRootLogin yes` temporarily enabled.

## 3. Manual Linkage
Run this **once** from exactly ONE Proxmox node:
```bash
pvecm qdevice setup <PI_IP>
