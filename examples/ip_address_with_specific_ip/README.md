# Simple Example

This example illustrates how to reserve a specific IP address (instead of
allowing GCP to dynamically assign it from the subnet provided).

[^]: (autogen_docs_start)
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| addresses | A list of IP addresses to create.  GCP will reserve unreserved addresses if given the value "".  If multiple names are given the default value is sufficient to have multiple addresses automatically picked for each name. | `list(string)` | n/a | yes |
| names | A list of IP address resource names to create.  This is the GCP resource name and not the associated hostname of the IP address.  Existing resource names may be found with `gcloud compute addresses list` (e.g. ["gusw1-dev-fooapp-fe-0001-a-001-ip"]) | `list(string)` | n/a | yes |
| project\_id | The project ID to deploy to | `string` | n/a | yes |
| region | The region to deploy to | `string` | n/a | yes |
| subnetwork | The subnetwork on which the IP address will be reserved | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| addresses | List of address values managed by this module (e.g. ["1.2.3.4"]) |
| names | List of address resource names managed by this module (e.g. ["gusw1-dev-fooapp-fe-0001-a-0001-ip"]) |
| project\_id | ID of the project being used |
| region | Region being used |

[^]: (autogen_docs_end)

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
