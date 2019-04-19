# Workshop "Migrating your apps to Kubernetes with Traefik"

## Requirements

- [Google Cloud SDK](https://cloud.google.com/sdk/docs/)
- [Terraform](https://www.terraform.io/downloads.html)
- [Packer](https://www.packer.io/downloads.html)
- [kubectl CLI](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- Variable `$GOOGLE_APPLICATION_CREDENTIALS` set, and pointing to your GCE's Service account JSON file (reference: <https://cloud.google.com/docs/authentication/production#obtaining_credentials_on_compute_engine_kubernetes_engine_app_engine_flexible_environment_and_cloud_functions#providing_service_account_credentials>)
- A Domain name you can create wildcard (or configure NS to Google zone)

## Quick Start

- Browse to `./terraform/packer`
- Build the VM Image with Packer: `packer build packer.json`
- Browse to `./terraform/`
- Generate a SSH Key (`id_rsa` and `id_rsa.pub`) into `./keys` (`ssh-keygen -t rsa -b 4096 -C "your_email@example.com")
- Init the project with `terraform init`
- Adapt the values in `variables.tf` (Region, VM template, domain)
- Start the platform with `terraform apply`
- Point your wildDNS to the IP reported by `terraform output bastion`
- Connect to the bastion with `eval $(terraform output bastion_ssh)`
- Get information about the labs with `terraform output attendees`
