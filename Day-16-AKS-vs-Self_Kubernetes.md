# 🚀 Kubernetes on Azure - Deployment Models (On-Prem vs VM vs AKS)

## 📌 Overview

This document explains different ways to deploy Kubernetes:

- 🏢 On-Premise (Self-Managed)
- ☁️ Azure VM-Based Kubernetes (Self-Managed)
- ⚡ AKS (Azure Kubernetes Service - Managed)

It also compares them across maintenance, cost, scalability, and integrations.

---

## 🧭 Deployment Options

```mermaid
flowchart LR
    A[Kubernetes Deployment Options] --> B[On-Premise]
    A --> C[Azure VM (Self-Managed)]
    A --> D[AKS (Managed)]

    B --> B1[Data Center]
    B --> B2[Manual Cluster Setup]

    C --> C1[Azure VMs]
    C --> C2[Manual K8s Setup]

    D --> D1[Managed Control Plane]
    D --> D2[Node Pools (VMSS)]


flowchart TD
    DC[Data Center] --> OS[OpenStack / Infra]
    OS --> M[Master Node]
    OS --> W1[Worker Node 1]
    OS --> W2[Worker Node 2]

    subgraph Kubernetes Cluster
        M
        W1
        W2
    end


flowchart TD
    AZ[Azure] --> VM1[VM - Master]
    AZ --> VM2[VM - Worker 1]
    AZ --> VM3[VM - Worker 2]

    subgraph Self-Managed Cluster
        VM1
        VM2
        VM3
    end


flowchart TD
    AZ[Azure AKS] --> CP[Managed Control Plane]
    AZ --> NP[Node Pool (VMSS)]

    CP --> API[API Server]
    CP --> SCH[Scheduler]
    CP --> ETCD[etcd]

    NP --> N1[Worker Node 1]
    NP --> N2[Worker Node 2]


| Feature                | On-Premise Kubernetes | Azure VM (Self-Managed K8s) | AKS (Managed K8s)     |
| ---------------------- | --------------------- | --------------------------- | --------------------- |
| **Infrastructure**     | Data Center           | Azure VMs                   | Azure Managed         |
| **Cluster Management** | Manual                | Manual                      | Managed               |
| **Control Plane**      | Self-managed          | Self-managed                | Managed by Azure      |
| **Maintenance**        | High                  | Moderate                    | Low                   |
| **Cost**               | High (hardware)       | Pay-as-you-go               | Optimized             |
| **Scaling**            | Manual                | Manual / Partial            | Auto-scaling          |
| **Availability**       | Limited               | Better                      | High                  |
| **Integration**        | Manual                | Azure-supported             | Native Azure          |
| **Security**           | Manual                | Improved                    | Built-in + Azure AD   |
| **Load Balancer**      | MetalLB               | Azure LB                    | Built-in              |
| **Storage**            | Manual CSI            | Azure Disk/File             | Native CSI            |
| **Secrets**            | Manual                | Azure supported             | Key Vault integration |
| **Node Management**    | Manual                | VM-based                    | Node Pools (VMSS)     |
| **Ease of Use**        | Hard                  | Medium                      | Easy                  |
