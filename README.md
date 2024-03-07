# [Google Address Terraform Module](https://registry.terraform.io/modules/terraform-google-modules/address/google/)

This terraform module provides the means to permanently reserve an [IP address](https://cloud.google.com/compute/docs/ip-addresses/)
available to Google Cloud Platform (GCP) resources, and optionally create
forward and reverse entries within Google Cloud DNS. The intent is to provide an
address resource which exists independent of the lifecycle of the resources
that require the address.

## Compatibility
This module is meant for use with Terraform 1.3+ and tested using Terraform 1.10+.
If you find incompatibilities using Terraform >=1.3, please open an issue.

If you haven't [upgraded to v6.0](./docs/upgrading_to_v6.0.md) and need the
previous `count`-based interface, the last released version supporting it is
[v5.0](https://registry.terraform.io/modules/terraform-google-modules/address/google/5.0.0).

## Examples without DNS

Examples are provided in the `examples` folder, but to simply reserve IP
addresses on a subnetwork without registering them in DNS refer to the
following example:

```hcl
module "address-fe" {
  source  = "terraform-google-modules/address/google"
  version = "~> 6.0"

  project_id = "gcp-network"
  region     = "us-west1"

  subnetwork = "projects/gcp-network/regions/us-west1/subnetworks/dev-us-west1-dynamic"

  addresses = [
    { name = "gusw1-dev-fooapp-fe-0001-a-001-ip" },
    { name = "gusw1-dev-fooapp-fe-0001-a-002-ip" },
    { name = "gusw1-dev-fooapp-fe-0001-a-003-ip" },
  ]
}
```

Then perform the following commands on the root folder:

- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

An `addresses` output has been provided as the list of IP addresses that were
reserved by GCP, in the same order as the `addresses` input. Because the
`address` attribute was not specified, GCP has reserved the next available IP
addresses from the subnetwork provided. Each entry in the `addresses` input
reserves one IP address, keyed in state by its `name`, so adding or removing
an entry does not affect the other reserved addresses.

If you would prefer to provide the specific IP addresses to be reserved, that
can be accomplished with the `address` attribute:

```hcl
module "address-fe" {
  source  = "terraform-google-modules/address/google"
  version = "~> 6.0"

  project_id = "gcp-network"
  region     = "us-west1"

  subnetwork = "projects/gcp-network/regions/us-west1/subnetworks/dev-us-west1-dynamic"

  addresses = [
    { name = "gusw1-dev-fooapp-fe-0001-a-001-ip", address = "10.11.0.10" },
    { name = "gusw1-dev-fooapp-fe-0001-a-002-ip", address = "10.11.0.11" },
    { name = "gusw1-dev-fooapp-fe-0001-a-003-ip", address = "10.11.0.12" },
  ]
}
```

Note that the IP addresses must not be reserved and must fall within the range of the provided subnetwork.

Most attributes may be set per address or once at the module level to act as
the default for every address that does not set its own value (e.g.
`address_type`, `subnetwork`, `labels`, and the `dns_*` settings).

### External IP address

External IP addresses can be reserved by setting the `global` attribute to `true` and omitting the subnetwork:

```hcl
module "address-fe" {
  source  = "terraform-google-modules/address/google"
  version = "~> 6.0"

  project_id = "gcp-network"
  region     = "us-west1"

  addresses = [
    { name = "external-facing-ip", global = true, address_type = "EXTERNAL" },
  ]
}
```

## DNS Examples

Optionally, the IP addresses you reserve can be registered in Google Cloud
DNS by providing information on the project hosting the Cloud DNS zone, the
managed zone name, the domain registered with Cloud DNS, setting the
`enable_cloud_dns` feature flag to `true`, and listing the DNS short names to
register for each address:

```hcl
module "address-fe" {
  source  = "terraform-google-modules/address/google"
  version = "~> 6.0"

  project_id = "gcp-network"
  region     = "us-west1"

  subnetwork       = "projects/gcp-network/regions/us-west1/subnetworks/dev-us-west1-dynamic"
  enable_cloud_dns = true
  dns_project      = "gcp-dns"
  dns_domain       = "example.com"
  dns_managed_zone = "nonprod-dns-zone"

  addresses = [
    { name = "gusw1-dev-fooapp-fe-0001-a-001-ip", dns_short_names = ["gusw1-dev-fooapp-fe-0001-a-001"] },
    { name = "gusw1-dev-fooapp-fe-0001-a-002-ip", dns_short_names = ["gusw1-dev-fooapp-fe-0001-a-002"] },
    { name = "gusw1-dev-fooapp-fe-0001-a-003-ip", dns_short_names = ["gusw1-dev-fooapp-fe-0001-a-003"] },
  ]
}
```

Multiple DNS names may be registered to the same address by listing several
`dns_short_names` on a single address.

### Reverse DNS

The module also supports the ability to register reverse DNS entries within
their own zone by setting the `enable_reverse_dns` feature flag to `true` and
specifying the zone with the `dns_reverse_zone` input variable:

```hcl
module "address-fe" {
  source  = "terraform-google-modules/address/google"
  version = "~> 6.0"

  project_id = "gcp-network"
  region     = "us-west1"

  subnetwork         = "projects/gcp-network/regions/us-west1/subnetworks/dev-us-west1-dynamic"
  enable_cloud_dns   = true
  enable_reverse_dns = true
  dns_project        = "gcp-dns"
  dns_domain         = "example.com"
  dns_managed_zone   = "nonprod-dns-zone"
  dns_reverse_zone   = "nonprod-dns-reverse-zone"

  addresses = [
    { name = "gusw1-dev-fooapp-fe-0001-a-001-ip", dns_short_names = ["gusw1-dev-fooapp-fe-0001-a-001"] },
    { name = "gusw1-dev-fooapp-fe-0001-a-002-ip", dns_short_names = ["gusw1-dev-fooapp-fe-0001-a-002"] },
    { name = "gusw1-dev-fooapp-fe-0001-a-003-ip", dns_short_names = ["gusw1-dev-fooapp-fe-0001-a-003"] },
  ]
}
```

The PTR record of an address points at the first entry of its
`dns_short_names`.

As with the non-DNS examples above, the `address` attribute can be provided
for each address to reserve specific IPs if desired.

## Input attributes that cannot contain computed values

Resources are keyed in state by address `name` (and by `name`/`dns_short_names`
pairs for DNS records) using `for_each`. Terraform requires `for_each` keys to
be known at plan time, so the following attributes of the `addresses` input
cannot be computed values:

```
name
dns_short_names
enable_cloud_dns
enable_reverse_dns
global
```

You must use literal values (or values known at plan time) for these
attributes. Other attributes, including `address` and `dns_domain`, may be
computed.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| address\_type | The default type of address to reserve, either "INTERNAL" or "EXTERNAL". If unspecified, defaults to "INTERNAL". | `string` | `"INTERNAL"` | no |
| addresses | A list of IP addresses to reserve, keyed by `name`. Each attribute left unset (`null`) falls back to the matching module-level variable when one exists. Set `address` to reserve a specific IP, leave it unset to let GCP pick one. Set `global` to true for a global address. `dns_short_names` registers forward DNS records for the address when `enable_cloud_dns` is set, and the first short name is used for the PTR record when `enable_reverse_dns` is set. | <pre>list(object({<br>    name               = string<br>    address            = optional(string)<br>    description        = optional(string)<br>    region             = optional(string)<br>    global             = optional(bool, false)<br>    address_type       = optional(string)<br>    subnetwork         = optional(string)<br>    ip_version         = optional(string)<br>    labels             = optional(map(string))<br>    purpose            = optional(string)<br>    network_tier       = optional(string)<br>    prefix_length      = optional(number)<br>    enable_cloud_dns   = optional(bool)<br>    enable_reverse_dns = optional(bool)<br>    dns_short_names    = optional(list(string), [])<br>    dns_domain         = optional(string)<br>    dns_managed_zone   = optional(string)<br>    dns_reverse_zone   = optional(string)<br>    dns_record_type    = optional(string)<br>    dns_ttl            = optional(number)<br>    dns_project        = optional(string)<br>  }))</pre> | n/a | yes |
| dns\_domain | The default domain to append to DNS short names when registering in Cloud DNS. | `string` | `""` | no |
| dns\_managed\_zone | The default name of the managed zone to create records within.  This managed zone must exist in the host project. | `string` | `""` | no |
| dns\_project | The default project where DNS records will be configured. Falls back to `project_id` if unset. | `string` | `""` | no |
| dns\_record\_type | The default type of records to create in the managed zone.  (e.g. "A") | `string` | `"A"` | no |
| dns\_reverse\_zone | The default name of the managed zone to create PTR records within.  This managed zone must exist in the host project. | `string` | `""` | no |
| dns\_ttl | The default DNS TTL in seconds for records created in Cloud DNS.  The default value should be used unless the application demands special handling. | `number` | `300` | no |
| enable\_cloud\_dns | If set, register records in Cloud DNS for addresses that do not set their own `enable_cloud_dns` attribute. | `bool` | `false` | no |
| enable\_reverse\_dns | If set, register reverse DNS PTR records in Cloud DNS for addresses that do not set their own `enable_reverse_dns` attribute. | `bool` | `false` | no |
| ip\_version | The default IP Version that will be used by the addresses. | `string` | `"IPV4"` | no |
| labels | The default labels to apply to the addresses. | `map(string)` | `{}` | no |
| network\_tier | The default networking tier used for configuring the addresses. | `string` | `"PREMIUM"` | no |
| prefix\_length | The default prefix length of the IP ranges. | `number` | `16` | no |
| project\_id | The project ID to create the addresses in | `string` | n/a | yes |
| purpose | The default purpose of the resource (GCE\_ENDPOINT, SHARED\_LOADBALANCER\_VIP, VPC\_PEERING, PRIVATE\_SERVICE\_CONNECT). | `string` | `"GCE_ENDPOINT"` | no |
| region | The default region to create regional addresses in. May be overridden per address with the `region` attribute. | `string` | n/a | yes |
| subnetwork | The default subnet containing the addresses.  For EXTERNAL addresses use the empty string, "".  (e.g. "projects/<project-name>/regions/<region-name>/subnetworks/<subnetwork-name>") | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| addresses | List of address values managed by this module (e.g. ["1.2.3.4"]), in the same order as the `addresses` input. |
| addresses\_map | Map of address values managed by this module, keyed by address name. |
| dns\_fqdns | List of DNS fully qualified domain names registered in Cloud DNS.  (e.g. ["gusw1-dev-fooapp-fe-0001-a-001.example.com", "gusw1-dev-fooapp-fe-0001-a-0002.example.com"]) |
| names | List of address resource names managed by this module (e.g. ["gusw1-dev-fooapp-fe-0001-a-0001-ip"]), in the same order as the `addresses` input. |
| reverse\_dns\_fqdns | List of reverse DNS PTR records registered in Cloud DNS.  (e.g. ["1.2.11.10.in-addr.arpa", "2.2.11.10.in-addr.arpa"]) |
| self\_links | List of URIs of the created address resources, in the same order as the `addresses` input. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Requirements
### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) >= 1.3
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin >= 5.2.0

### Configure a Service Account
In order to execute this module you must have a Service Account with the following roles:

- roles/dns.admin on the project (for DNS registration)
- roles/compute.networkAdmin on the organization (or the host project that defines the network)

#### Script Helper
A [helper script](./helpers/setup-sa.sh) is included to automatically grant all the
required roles at the project level. The `roles/compute.networkAdmin` can
either be assigned at the project level on the project hosting the network
and subnetworks where IP addresses will be reserved, or at the organization
level. The `setup-sa.sh` script will assign it at the project level on the
host project that is passed in. If this is not what you need then you will
need to adjust permissions accordingly.

Run the script as follows:

```
./helpers/setup-sa.sh <HOST_PROJECT_NAME> <SERVICE_ACCOUNT_NAME>
```

The `SERVICE_ACCOUNT_NAME` can be whatever you want the service account to be
named. Successful completion of the `setup-sa.sh` script will result in a
credentials file called `credentials.json` that can be used with
`gcloud` or referenced by the module tests.

### Enable API's
In order to operate with the Service Account you must activate the following API on the project where the Service Account was created:

- Compute Engine API - compute.googleapis.com
- Google Cloud DNS API - dns.googleapis.com

NOTE: These APIs are enabled by default on the host project passed in to the `./helpers/setup-sa.sh` helper script.

## Install

### Terraform
Be sure you have the correct Terraform version (0.12.x), you can choose the binary here:
- https://releases.hashicorp.com/terraform/

## File structure
The project has the following folders and files:

- /: root folder
- /examples: examples for using this module
- /test: Folders with files for testing the module (see Testing section on this file)
- /main.tf: main file for this module, contains all the resources to create
- /variables.tf: all the variables for the module
- /output.tf: the outputs of the module
- /README.md: this file
