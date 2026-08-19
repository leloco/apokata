<div align="center">
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse; margin: 0 auto; padding: 0; border: none; background: transparent; max-width: 100%;">
  <tr>
    <td valign="middle" style="border: none; padding: 0 15px 0 0; background: transparent;">
      <img src="docs/assets/logo.svg" alt="Apokata Logo" width="64" height="64" style="display: block; width: 64px; height: 64px; border: none; margin: 0; padding: 0;" />
    </td>
    <td valign="top" style="border: none; padding: 0; background: transparent; white-space: nowrap;">
      <h1 style="border: none; margin: 0; padding: 0; font-size: 2.25rem; font-weight: 600; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Helvetica, Arial, sans-serif; background: transparent;">
        apokata
      </h1>
    </td>
  </tr>
</table>
</div>

<br>

> **An automated, reproducible infrastructure platform applying enterprise patterns to a self-hosted environment with production-grade services.**

[![Infrastructure Deployment](https://github.com/leloco/apokata/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/leloco/apokata/actions/workflows/main.yml)
[![Infrastructure Package Upgrades](https://github.com/leloco/apokata/actions/workflows/upgrade.yml/badge.svg?branch=main)](https://github.com/leloco/apokata/actions/workflows/upgrade.yml)
[![Deploy MkDocs to Pages](https://github.com/leloco/apokata/actions/workflows/docs.yml/badge.svg)](https://github.com/leloco/apokata/actions/workflows/docs.yml)

---

## Executive Summary

**apokata** (derived from Greek for _restoration/reconstitution_) is a fully automated, reproducible hybrid infrastructure environment built on GitOps principles.

It demonstrates enterprise-grade platform engineering patterns on physical hardware—from bare-metal hypervisors to edge networking and container orchestration. The entire state is managed declaratively through Infrastructure as Code (IaC) and Configuration as Code (CaC), guaranteeing a **zero-touch disaster recovery** model where the repository itself is the single source of truth.

---

## Architectural Highlights

- **Declarative Provisioning (IaC):** OpenTofu (Terraform) provisions Proxmox VE resources via custom, reusable modules using an encrypted Cloudflare R2 state backend.
- **Automated Configuration (CaC):** Ansible orchestrates host bootstrapping, software runtime setups, and service hardening against auto-generated inventories.
- **GitOps & Secure CI/CD:** Hybrid deployment pipeline running via GitHub Actions triggered on self-hosted runners, ensuring infrastructure secrets never leave the local network.
- **Zero-Trust Network Isolation:** Segmented multi-VLAN topology (OPNsense) with strict firewall boundaries, zero exposed public ports, and encrypted edge access via Cloudflare Tunnels / WireGuard.
- **High-Availability Services:** Redundant DNS architecture (dual Pi-hole/Unbound) with VRRP failover (`keepalived`) and zero single-point-of-failure name resolution.
- **Disaster Recovery & Security:** Automated Network-Bound Disk Encryption (Tang/NBDE), 3-2-1 backup policies via Proxmox Backup Server (PBS) over encrypted VPNs, and SOPS/Ansible-Vault secret management.

👉 **[View Architectural Decision Records (ADRs)](https://github.com/leloco/apokata/tree/main/docs/adr)**

---

## Apokata Docs

👉 **[View docs](https://leloco.github.io/apokata/)**

---

## Repository Layout

```text
.
├── .github/              # Actions Workflows & Custom Actions
├── ansible/              # Playbooks, Roles & Dynamic Inventory Templates
├── opentofu/
│   ├── infra/            # Core Infrastructure & Compute Declarations
│   └── runner/           # Dedicated CI/CD Runner Environment
└── scripts/              # Pre-commit hooks & Notification Utilities
```
