# Global external IPv6 address

This example illustrates how to reserve a global external IPv6 address.

The IPv6 address is dynamically assigned by Google Cloud.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The Google Cloud project ID | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| addresses | IP address |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
