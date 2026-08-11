# 0004-decouple-lvm-volumes

- **Status:** Accepted
- **Date:** 2026-08-11
- **Deciders:** leloco

## Context & Problem
When deploying Proxmox LXCs via OpenTofu, default storage assignments follow the `vm-<VMID>-disk-<X>` pattern.

If core infrastructure containers (e.g., Nginx Proxy Manager, databases, auth services) are destroyed or recreated—such as during a full IaC stack redeployment or OS template upgrade—Proxmox automatically purges all volumes matching that VMID pattern. This leads to catastrophic data loss for persistent application states and databases.

## Decision
We decouple persistent data volumes from the LXC lifecycle by using custom LVM-Thin volume names that do not follow the official regex pattern with `vm_id` and `disk` info (e.g. `local-lvm:npm-disk-1`).

OpenTofu modules will explicitly mount these pre-existing or independently created volumes to containers with the following naming convention: `vm-<vm_id>-data`

---

## Consequences

### Pros
* **Stateless Recreation:** Containers can be destroyed, recreated, or migrated via IaC without risking persistent database or configuration loss.
* **Full Stack Redeployment:** Allows tearing down and rebuilding the entire OpenTofu infrastructure layer while keeping state intact.
* **OS Upgrades:** Enables clean LXC OS template upgrades (e.g., Debian 11 -> 12) by simply re-attaching the detached volume to a new container.

### Cons
* **Manual Cleanup:** Discarding a service permanently requires deleting the LVM volume manually on the Proxmox CLI (`lvremove`).
* **Initial Setup Overhead:** Custom volumes must be created or renamed prior to or alongside the IaC state definition.

---

## Implementation

### 1. Rename Existing Volume (Proxmox CLI)
```bash
pct stop <VMID>
# Unmount volume in /etc/pve/lxc/<VMID>.conf first, then:
lvrename pve vm-<VMID>-disk-1 <naming-convention>
