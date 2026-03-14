# apokata

[![Infrastructure Deployment](https://github.com/leloco/apokata/actions/workflows/main.yml/badge.svg?branch=main)](https://github.com/leloco/apokata/actions/workflows/main.yml)

- [apokata](#apokata)
  - [Project Overview](#project-overview)
  - [Motivation](#motivation)
  - [Main Components](#main-components)
    - [brainstorm](#brainstorm)
    - [ninja](#ninja)
    - [shadow](#shadow)
    - [sentinel](#sentinel)
  - [Design Decisions](#design-decisions)
  - [What is running on](#what-is-running-on)
    - [brainstorm](#brainstorm-1)
    - [ninja](#ninja-1)
    - [shadow](#shadow-1)
    - [sentinel](#sentinel-1)
  - [Getting started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Local repository](#local-repository)
    - [Folder structure](#folder-structure)
    - [Deployment](#deployment)
      - [runner](#runner)
      - [infra](#infra)
    - [Secrets and variables](#secrets-and-variables)
  - [Goals for 2026](#goals-for-2026)
  - [More documentation](#more-documentation)

## Project Overview

**Apokata** is an on-premise homelab environment designed for automated self-hosting, privacy-focused services, and continuous learning.

The name is derived from the Greek _apokatastasis_, meaning "restoration" or "reconstitution."

This project embodies the philosophy of an **easy reproducible infrastructure**. On this on-premise environment services are not simple hosted, but engineered to be resilient, automated, and easily restored(Zero-Touch-Architecture).

## Motivation

Data privacy and digital freedom have always been deeply important to me. It all started back in 2019, when I took my first leap into self-hosting: a lone Toshiba laptop with 4GB of RAM, running an old Ubuntu, Apache, and Nextcloud.

Some day the server crashed, and because I hadn't written a single step down, my digital home was gone. I had no documentation to rebuild it and no easy way to recover.

This failure changed everything. As I moved my growing lab to more robust hardware and hypervisors like Proxmox, I realized that "just making it work" wasn't enough. I needed a way to make my infrastructure sustainable and reproducible. Whether I’m migrating to new hardware, replicating services for friends and family, or simply trying to remember a config from six months ago—I needed a blueprint.

This project is the result of that journey and will continue to grow. It’s the move from a fragile laptop under the desk to a professional, "Zero-Touch" environment. This is the core of **apokata**: The code is the documentation and restoration is just a command away.

## Main Components

### brainstorm

- Fujitsu Futro S940 Thin Client
- OS: FreeBSD
- RAM: 4GB
- Storage: 256 GB .M2 SSD
- Advantages: Low power usage, dual NIC support for WAN and LAN

### ninja

- HP EliteDesk 800 G4 DM
- OS: Debian
- RAM: 16 GB
- Storage: 1TB WD RED HDD, 256 GB .M2 Samsung SSD
- Advantages: Low power usage

### shadow

- Raspberry Pi 3
- OS: Ubuntu
- RAM: 2 GB
- Storage: 32GB SD-Card
- Advantages: Low power usage

### sentinel

- Fujitsu ESPRIMO P500 E85
- OS: Debian
- RAM: 8 GB
- Storage: 4TB Ironwolf HDD, 256 GB Samsung SSD
- Advantages: Low power usage, space for multiple 3,5" disks

## Design Decisions

- **Proxmox Ecosystem**: Chosen as the primary hypervisor for its enterprise-grade reliability, open-source nature, and native support for snapshots—essential for rapid testing and "Apokatastasis" (restoration).

- **ZFS Filesystem**: Implemented on all PVE and PBS nodes to ensure data integrity (bitrot protection), efficient compression, and seamless snapshot-based backups.

- **Segmented Networking (OPNsense)**: Leverages VLANs and strict firewall rules to isolate untrusted IoT devices from the core infrastructure, ensuring a granular security posture.

- **Centralized Access (Custom Domain)**: Uses a dedicated domain for streamlined service discovery and automated SSL certificate management via Let's Encrypt/ACME.
- **Service Security** Zero public-facing ports. External access is strictly limited to Wireguard VPN or Cloudflare Tunnels, minimizing the attack surface to a minimum

- **Redundant DNS and Ad-blocker (High Availability)**: Dual Pi-hole instances provide network-wide ad-blocking with automatic failover, ensuring no single point of failure for name resolution.

- **3-2-1 Backup Strategy**: A remote PBS at a secondary location, connected via encrypted VPN, ensures disaster recovery even in the event of total local site failure.

- **Infrastructure as Code (IaC) and Configuration as Code (CaC)**: Git serves as the single source of truth for the entire environment. By leveraging OpenTofu (Terraform) for declarative provisioning and Ansible for automated configuration management, the entire infrastructure is version-controlled, auditable, and fully reproducible from scratch.

- **Dual-Stack Setup**: Every device and service—including both DNS resolvers—is configured for full IPv4 and IPv6 connectivity. This ensures future-proof access and eliminates "bottlenecks" in modern network environments.

- **Secure CI/CD (GitHub & Self-Hosted Runners)**: While GitHub is used as the primary platform for transparency and collaboration, all automation workflows are executed on Self-Hosted Runners. This architecture ensures that specific infrastructure credentials and deployment tasks remain entirely within the private network, eliminating the need to expose internal APIs to the public internet.

## What is running on

### brainstorm

- OPNSense as router and firewall

### ninja

Proxmox-Virtual-Environment Server with following LXCs and VMs:

| Name                    | Description                                                                                                                                | Type            |
| :---------------------- | :----------------------------------------------------------------------------------------------------------------------------------------- | :-------------- |
| **Nextcloud**           | Multi-user collaboration hub with Redis caching, OnlyOffice integration for real-time document editing and Password Management (KeePassXC) | LXC             |
| **Tang**                | Automated Network Bound Disk Encryption (NBDE); unlocks LUKS partitions on boot only when connected to your secure home network            | LXC             |
| **Portainer**           | Centralized Docker management using Stacks/Compose.                                                                                        | LXC with docker |
| **ioBroker**            | IoT bridge for Shelly devices; logs real-time power metrics into InfluxDB for advanced Grafana energy dashboards                           | LXC with docker |
| **ejabberd**            | Hardened XMPP server supporting OMEMO encryption; acts as a private, self-hosted messaging and alert gateway                               | LXC with docker |
| **Pi-hole + Unbound**   | DNS blackhole for ad-blocking combined with a recursive resolver to bypass third-party DNS tracking                                        | LXC             |
| **Reverse Proxy (NPM)** | Entry point for all services with automated Let’s Encrypt SSL                                                                              | LXC with docker |
| **GitHub Runner**       | Isolated VM for CI/CD pipelines; automates infrastructure deployment in docker.                                                            | VM with docker  |

### shadow

- **PiHole** with unbound as DNS resolver

### sentinel

- **PBS** with nightly triggered encrypted backups of all VMs and LXCs

## Getting started

Every homelab has unique hardware, VLAN IDs, and IP ranges, you should not clone it directly to deploy. Instead, follow these steps to create your own independent environment.

### Prerequisites

- You have a running PVE-Server and generated an API-Token for managing your infrastructure with OpenTofu.
- A remote backend for infrastructure state tracking (e.g. Cloudflare R2 object storage)

### Local repository

After cloning the repository you need to set the `/scripts/githooks` folder as default `hooksPath` for your local git repository.

Run this command from project root:

```bash
git config core.hooksPath scripts/githooks
```

This is a security feature that makes sure that commits can only be successful if specific files inside the repo are encrypted with SOPS.

### Folder structure

The repository consists of two main folders `opentofu` and `ansible`.

Inside `opentofu` are two folders `infra` and `runner`.

The `runner` folder gathers everything around the configuration of the runner. It has its own OpenTofu declaration and needs to deployed separately because it is the executor to validate, configure and deploy the infrastructure that is definied inside `infra`.

The `infra` folder contains everything for managing PVE with OpenTofu. Custom modules for VMs and LXCs are here defined.

The other main folder `ansible` has two main playbooks for configuring infrastructure hosts `infra_playbook.yml` and the runner itself `runner_playbook.yml`. The `inventory.ini` is **auto-generated** with help of the `infra/main.tf` file.

### Deployment

#### runner

You need to deploy the GitHub Runner obviously only from your local repository.

Runner architecture changes? Run `tofu plan`, `tofu apply` inside `opentofu/runner`
Runner software configuration changes? Run `ansible-playbook -i inventory.ini runner_playbook.yml` inside `ansible`

#### infra

You can deploy the main infrastructure from your local repository or through the GitHub runner.

The workflow is the same as for the GitHub Runner but:

- For running the OpenTofu commands inside `opentofu/infra` **locally** you need to define two environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` because the infrastructure state is secured with a remote backend (S3 Bucket from Cloudflare). **You do not need to configure this if you choose to deploy via GitHub**.
- For Ansible use `ansible-playbook -i inventory.ini infra_playbook.yml`

### Secrets and variables

The GitHub workflow / CI/CD Pipeline inside `.github/workflows` needs these secrets definied on GitHub (`repo-name/settings/secrets/actions`):

- `AWS_ACCESS_KEY_ID` for Cloudflare R2 object storage
- `AWS_SECRET_ACCESS_KEY` for Cloudflare R2 object storage
- `GPG_KEY` for SOPS decryption of critical files
- `SSH_PRIVATE_KEY` for Ansible to connect to the specific hosts
- `SSH_PUBLIC_KEY` for Ansible for enabling public key authentication
- `ANSIBLE_VAULT_PASSWORD` for decrypting Ansible secrets while running playbooks

## Goals for 2026

- [x] Migrate DNS servers from ClickOps to IaC with HA through keepalived
- [x] Migrate tang from ClickOps to IaC
- [ ] [Refactor from Old Architecture to New Architecture](https://github.com/leloco/apokata/wiki/New-Architecture)
- [ ] Migrate Nextcloud from ClickOps to IaC
- [ ] Migrate ejabberd and ioBroker from ClickOps to Virtual 3-Node K3S
- [ ] Configure Authentik as central IdP for SSO (Proxmox, Nextcloud, etc.)
- [ ] Track energy consumption of ninja, brainstorm, sentinel, shadow with shelly devices and Grafana
- [ ] Enable notifications and security alerts with XMPP and Go

## More documentation

Checkout the [apokata wiki](https://github.com/leloco/apokata/wiki) for more detailed documentation.
