# 0006-monitoring-stack

- **Status:** Accepted
- **Date:** 2026-08-20
- **Deciders:** leloco

## Context

A central observability platform is required to monitor bare-metal hosts, LXCs, VMs, network appliances, and Kubernetes clusters independently of workload cluster availability.

## Decision Drivers

- Core monitoring must survive Kubernetes outages (out-of-cluster deployment).
- Low overhead and unified management (single host for the core stack).
- Avoid cross-VLAN scraping into ephemeral Kubernetes pod networks.
- Reliable alerting with defined primary and fallback channels.

## Considered Options

- **Option 1:** Monolithic monitoring deployed entirely inside Kubernetes.
- **Option 2:** Distributed architecture with separate LXCs per component (Prometheus, Grafana, Alertmanager).
- **Option 3 (Chosen):** Single dedicated Core LXC running Prometheus, Grafana, and Alertmanager via Docker Compose + Prometheus Agent in Kubernetes.

## Decision Outcome

Chosen option: **Option 3**.

Deploy a single Proxmox LXC container hosting the entire central monitoring stack (Prometheus, Grafana, Alertmanager) orchestrated via Docker Compose.

Kubernetes clusters deploy a lightweight Prometheus in **Agent Mode** (`--enable-feature=agent`) to scrape in-cluster resources and stream metrics out via `remote_write`.

### Component Details & Requirements

- **Central Monitoring LXC (Docker Compose):**
  - **Prometheus (Server):** Runs with `--web.enable-remote-write-receiver` to accept metrics pushed from edge agents via `/api/v1/write`. Long-term TSDB storage capped at 30 days / 50 GB with WAL compression.
  - **Grafana:** Co-located in the same Compose stack to visualize metrics from the central Prometheus. Dashboards and data sources provisioned as code.
  - **Alertmanager:** Co-located in the same Compose stack. Handles deduplication and alert dispatching:
    - **Primary:** Self-hosted Rocket.Chat (via webhook integration).
    - **Fallback:** Email with Resend (SMTP).
- **Edge / Kubernetes:**
  - **Prometheus Agent:** Dedicated in-cluster instance handling local discovery (Pods, Nodes, Services) and pushing time-series upstream without storing local historical TSDB blocks.
- **Exporters:** Node Exporter deployed and managed across all Proxmox hypervisors, storage nodes, and Linux hosts via Ansible (plus dedicated SNMP/native plugins for network appliances).

## Pros and Cons

- **Positive:** Central monitoring and dashboards remain fully operational even if the Kubernetes cluster goes down.
- **Positive:** All core components (Prometheus, Grafana, Alertmanager) share a single isolated network and lifecycle in one LXC.
- **Positive:** In-cluster Agent mode eliminates complex firewall rules for cross-VLAN pod scraping.
- **Negative:** Single LXC represents a single point of failure for dashboards and central metric ingestion (mitigated by automated backups/IaC).
