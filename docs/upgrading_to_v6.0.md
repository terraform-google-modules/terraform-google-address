# Upgrading to v6.0

The v6.0 release is a backwards incompatible release. The module now uses
`for_each` instead of `count` to manage its resources, so addresses are keyed
in state by their name instead of their position in a list. Adding or removing
an address no longer affects the other addresses managed by the module.

## Terraform version

Terraform 1.3 or later is required (the `addresses` variable uses `optional()`
object attributes).

## Input changes

The `names`, `global`, `dns_short_names`, and `descriptions` list variables
were removed, and the `addresses` variable changed from a list of IP strings to
a list of objects — one object per address to reserve:

```diff
 module "address" {
   source  = "terraform-google-modules/address/google"
-  version = "~> 5.0"
+  version = "~> 6.0"

   project_id       = var.project_id
   region           = var.region
   subnetwork       = var.subnetwork
   enable_cloud_dns = true
   dns_domain       = "example.com"
   dns_managed_zone = "nonprod-dns-zone"

-  names           = ["my-ip-1", "my-ip-2"]
-  addresses       = ["10.0.0.10", "10.0.0.11"]
-  dns_short_names = ["short-1", "short-2"]
+  addresses = [
+    { name = "my-ip-1", address = "10.0.0.10", dns_short_names = ["short-1"] },
+    { name = "my-ip-2", address = "10.0.0.11", dns_short_names = ["short-2"] },
+  ]
 }
```

Every module-level variable that used to apply to all addresses
(`address_type`, `subnetwork`, `labels`, `purpose`, `network_tier`,
`prefix_length`, `ip_version`, `region`, and the `dns_*` and `enable_*`
variables) still exists and acts as the default, and can now also be
overridden per address with the attribute of the same name.

Each address object supports the following attributes (only `name` is
required): `address`, `description`, `region`, `global`, `address_type`,
`subnetwork`, `ip_version`, `labels`, `purpose`, `network_tier`,
`prefix_length`, `enable_cloud_dns`, `enable_reverse_dns`, `dns_short_names`,
`dns_domain`, `dns_managed_zone`, `dns_reverse_zone`, `dns_record_type`,
`dns_ttl`, and `dns_project`.

## Output changes

Outputs keep the same names and list shapes, ordered by the `addresses` input.
A new `addresses_map` output exposes the reserved IPs keyed by address name.

## State migration

Because resources are now keyed by name instead of index, existing resources
must be moved in state to avoid destroying and recreating the reserved
addresses. For each address, add a `moved` block (or run the equivalent
`terraform state mv` commands):

```hcl
moved {
  from = module.address.google_compute_address.ip[0]
  to   = module.address.google_compute_address.ip["my-ip-1"]
}
```

The same applies to `google_compute_global_address.global_ip` (keyed by name),
`google_dns_record_set.ip` (now keyed by `"<address name>/<dns short name>"`),
and `google_dns_record_set.ptr` (keyed by address name).

Run `terraform plan` after the migration and confirm that no resources are
planned for destruction.
