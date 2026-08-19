# 0001-hybrid-architecture-with-two-zones

- **Status:** Accepted
- **Date:** 2026-08-07
- **Deciders:** leloco

## Context

The whole infrastructure includes two zones: Zone 1 (Mutable) and Zone 2 (Immutable) components.

## Decision

We establish a strict **two-zone operational model**:

1. **Zone 1: Mutable Infrastructure**
   - **Scope:** Core Infrastructure: OPNSense, Proxmox VE, Proxmox BS, DNS Servers, Unifi Controller, Tang Servers, RocketChat, Nginx Proxy Manager, Keycloak
   - **Network**: VLAN Core
   - **Management:** Installed manually or provisioned via OpenTofu, configured and maintained live via Ansible.

2. **Zone 2: Immutable Infrastructure**
   - **Scope:** Kubernetes Control Plane and Worker Nodes, GitHub Self-hosted runners
   - **Network**: VLAN Lab
   - **Management:** Fully immutable. In-place updates are prohibited. Node updates and OS patches occur exclusively via automated VM replacements using Packer templates with the help of OpenTofu and Ansible.

## Consequences

- **Positive:** Core infrastructure remains undisturbed and separated.
- **Negative / Trade-offs:** Every core infrastructure component needs a solid backup strategy for fast recovery.
