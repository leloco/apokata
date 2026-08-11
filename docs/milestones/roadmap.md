# Roadmap

## M1: Zone 1 Hardening and Backup

> **Context:**
> * **Goal:** Provision core LXC services and establish PBS and Cloudflare R2 backup pipelines.
> * **Related ADRs:** [ADR-0001](../adr/0001-hybrid-architecture-with-two-zones.md), [ADR-0002](../adr/0002-backup-strategy-of-zone-1-components.md)

### GitHub Sync Status

- [x] **Milestone created:** [1](https://github.com/leloco/apokata/milestone/1)
- [ ] **Issues created:**
  - [x] Migrate `z1-npm` LXC -> https://github.com/leloco/apokata/issues/102
  - [ ] Migrate `z1-portainer` LXC -> https://github.com/leloco/apokata/issues/110
  - [ ] `TBD` - Migrate `z1-ejabberd` LXC
  - [ ] `TBD` - Migrate `z1-iobroker` LXC
  - [ ] `TBD` - Create `z1-rocketchat` LXC
  - [ ] `TBD` - Recreate `z1-tang` LXC
  - [ ] `TBD` - Recreate `z1-prowl` LXC
  - [ ] `TBD` - Recreate `z1-unifi` LXC
  - [ ] `TBD` - Validate PBS snapshot job for all Zone 1 LXCs
  - [ ] `TBD` - Automate proxy hosts config in z1-npm
  - [ ] `TBD` - Deploy Ansible role for Cloudflare R2 encrypted config export for dedicated LXCs

### Definition of Done (DoD)
- [ ] Code is formatted and passes linter checks (`tofu fmt`, `ansible-lint`)
- [ ] All GitHub Issues associated with this milestone are closed
- [ ] Disaster recovery / restoration path has been tested

---

## M2: Shared Storage Architecture

> **Context:**
> * **Goal:** Integrate two storage pools from NAS into both Proxmox nodes via NFS and dedicated SAN
> * **Related ADRs:**
### GitHub Sync Status

- [x] **Milestone created:** [2](https://github.com/leloco/apokata/milestone/2)
- [ ] **Issues created:**
  - [] `TBD` Build NAS, configure storage and document important configurations
  - [] `TBD` Integrate HDD Pool via NFS into both Proxmox hosts
  - [] `TBD` Integrate SSD Pool via NFS into both Proxmox hosts
  - [] `TBD` Create backup solution for NAS zfs snapshots on sentinel

### Definition of Done (DoD)

- [] Storage mounts verified on both PVE hosts (pvesm status, mount persistence checked after reboot)
- [] NFS write performance & latency benchmarked under load (sync=disabled verified)
- [] All GitHub Issues associated with this milestone are closed
- [] Disaster recovery / restoration path has been tested
