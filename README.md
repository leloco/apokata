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

- A OPNSense server that runs on a Fujitsu Futro S940 Thin Client

### ninja

- A Proxmox-Virtual-Environment (PVE) server that runs on a HP EliteDesk 800 G4 DM

### shadow

- A Pihole Adblocker with unbound as DNS running on a Raspberry Pi 3

### sentinel

- A Proxmox-Backup-Server (PBS) that is running on a Fujitsu ESPRIMO P500 E85

## Design Decisions

- **Proxmox Ecosystem**: Chosen as the primary hypervisor for its enterprise-grade reliability, open-source nature, and native support for snapshots—essential for rapid testing and "Apokatastasis" (restoration).

- **ZFS Filesystem**: Implemented on all PVE and PBS nodes to ensure data integrity (bitrot protection), efficient compression, and seamless snapshot-based backups.

- **Segmented Networking (OPNsense)**: Leverages VLANs and strict firewall rules to isolate untrusted IoT devices from the core infrastructure, ensuring a granular security posture.

- **Centralized Access (Custom Domain)**: Uses a dedicated domain for streamlined service discovery and automated SSL certificate management via Let's Encrypt/ACME.
- **Service Security** Zero public-facing ports. External access is strictly limited to Wireguard VPN or Cloudflare Tunnels, minimizing the attack surface to a minimum

- **Redundant DNS and Ad-blocker (High Availability)**: Dual Pi-hole instances provide network-wide ad-blocking with automatic failover, ensuring no single point of failure for name resolution.

- **3-2-1 Backup Strategy**: A remote PBS at a secondary location, connected via encrypted VPN, ensures disaster recovery even in the event of total local site failure.

- **Infrastructure as Code (IaC)**: Git serves as the single source of truth for the entire environment. By leveraging OpenTofu (Terraform) for declarative provisioning and Ansible for automated configuration management, the entire infrastructure is version-controlled, auditable, and fully reproducible from scratch.

- **Secure CI/CD (GitHub & Self-Hosted Runners)**: While GitHub is used as the primary platform for transparency and collaboration, all automation workflows are executed on Self-Hosted Runners. This architecture ensures that specific infrastructure credentials and deployment tasks remain entirely within the private network, eliminating the need to expose internal APIs to the public internet.

## What is running on

### brainstorm

- OPNSense as router and firewall

### ninja

- **Nextcloud**: Multi-user collaboration hub with Redis caching, OnlyOffice integration for real-time document editing and Password Management (KeePassXC)
- **Tang**: Automated Network Bound Disk Encryption (NBDE); unlocks LUKS partitions on boot only when connected to your secure home network
- **Portainer**: Centralized Docker management using Stacks/Compose.
- **ioBroker**: IoT bridge for Shelly devices; logs real-time power metrics into InfluxDB for advanced Grafana energy dashboards
- **ejabberd**: Hardened XMPP server supporting OMEMO encryption; acts as a private, self-hosted messaging and alert gateway
- **Pi-hole + Unbound**: DNS blackhole for ad-blocking combined with a recursive resolver to bypass third-party DNS tracking
- **Reverse Proxy (NPM)**: Entry point for all services with automated Let’s Encrypt SSL
- **GitHub Runner**: Isolated VM for CI/CD pipelines; automates local Docker builds and deployments directly from your repos.

### shadow

- **PiHole** with unbound as DNS resolver

### sentinel

- **PBS** with nightly triggered encrypted backups of all VMs and LXCs

## Getting started

## Goals for 2026

## More documentation

Checkout the [apokata wiki](https://github.com/leloco/apokata/wiki).
