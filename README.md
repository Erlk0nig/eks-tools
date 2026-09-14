# eks-tools

Terraform and GitHub Actions for the second part of the EKS project.

This repository does not create the Kubernetes cluster itself. It is the add-on layer that is applied after the base infrastructure from the first project, `aws-eks-project`, is already available.

The first project repository is here: [aws-eks-project](https://github.com/your-org/aws-eks-project).

The first project provisions the AWS foundation and EKS cluster. This repository installs and configures the in-cluster tooling that sits on top of it:

- cert-manager for TLS certificate management
- Envoy Gateway for ingress and gateway routing
- kube-prometheus-stack for Grafana and Prometheus

## What this repo deploys

- `cert-manager` namespace, Helm release, and cluster issuer
- `envoy-gateway-system` namespace, Helm release, and EnvoyProxy configuration
- `monitoring` namespace and `kube-prometheus-stack` Helm release
- Gateway, HTTPRoute, and certificate manifests for Grafana and Prometheus

## Repository layout

- `cert-manager.tf` - cert-manager namespace, Helm release, and issuer resources
- `envoy_proxy_gateway.tf` - Envoy Gateway installation and EnvoyProxy manifest
- `kube-prometheus-stack.tf` - monitoring namespace and kube-prometheus-stack release
- `gateway.tf` - Gateway and HTTPRoute resources
- `certificate.tf` - TLS certificate resources
- `variables.tf` - Terraform input variables
- `.github/workflows/install-tools.yml` - workflow to deploy the tooling layer
- `.github/workflows/uninstall-tools.yml` - workflow to remove the tooling layer

## Prerequisites

- An existing EKS cluster from the first project
- AWS credentials with access to the cluster and the Terraform backend bucket
- A working Terraform state backend in S3
- GitHub Actions secrets for AWS and backend configuration

## GitHub Actions inputs

The deploy workflow is driven from `workflow_dispatch` and expects these inputs:

- `workspace` - Terraform workspace to use
- `cluster_name` - existing EKS cluster name
- `grafana_hostname` - public hostname used for Grafana
- `prometheus_hostname` - public hostname used for Prometheus

The workflow also expects these secrets:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_REGION`
- `TF_BACKEND_S3_BUCKET_NAME`
- `TF_BACKEND_S3_BUCKET_KEY`
- `TF_BACKEND_S3_BUCKET_REGION`

## Deploy

1. Open the GitHub Actions tab.
2. Run `Provision tools`.
3. Select the Terraform workspace.
4. Provide the target EKS cluster name.
5. Provide the public hostnames for Grafana and Prometheus.
6. Review and apply the plan.

The workflow runs `terraform init`, selects or creates the workspace, then runs `plan` and `apply` with the supplied variables.

## Destroy

Use the `Destroy tools` workflow to remove the tooling stack from the cluster. It takes the same `workspace` and `cluster_name` inputs and runs `terraform plan -destroy` followed by `terraform destroy`.

## Notes

- This repository assumes the cluster and AWS base networking already exist.
- If you update the hostnames, rerun the provisioning workflow so cert-manager, Gateway, and HTTPRoute resources are reconciled with the new values.