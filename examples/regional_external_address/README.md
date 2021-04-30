# Regional external IPv4 address

This example illustrates how to reserve a regional external IPv4 address.

The IP address is dynamically assigned by Google Cloud.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The Google Cloud project ID to deploy to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| addresses | List of address values managed by this module |
| names | List of address resource names |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
