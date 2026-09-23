/**
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

output "addresses" {
  description = "List of address values managed by this module (e.g. [\"1.2.3.4\"]), in the same order as the `addresses` input."
  value       = [for addr in var.addresses : local.ip_addresses[addr.name]]
}

output "addresses_map" {
  description = "Map of address values managed by this module, keyed by address name."
  value       = local.ip_addresses
}

output "names" {
  description = "List of address resource names managed by this module (e.g. [\"gusw1-dev-fooapp-fe-0001-a-0001-ip\"]), in the same order as the `addresses` input."
  value       = [for addr in var.addresses : addr.name]
}

output "self_links" {
  description = "List of URIs of the created address resources, in the same order as the `addresses` input."
  value       = [for addr in var.addresses : local.self_links[addr.name]]
}

output "dns_fqdns" {
  description = "List of DNS fully qualified domain names registered in Cloud DNS.  (e.g. [\"gusw1-dev-fooapp-fe-0001-a-001.example.com\", \"gusw1-dev-fooapp-fe-0001-a-0002.example.com\"])"
  value       = flatten([for addr in var.addresses : local.dns_fqdns[addr.name]])
}

output "reverse_dns_fqdns" {
  description = "List of reverse DNS PTR records registered in Cloud DNS.  (e.g. [\"1.2.11.10.in-addr.arpa\", \"2.2.11.10.in-addr.arpa\"])"
  value       = [for addr in var.addresses : local.dns_ptr_fqdns[addr.name] if contains(keys(local.dns_ptr_fqdns), addr.name)]
}
