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
  description = "List of address values managed by this module (e.g. [\"1.2.3.4\"])"
  value       = module.example.addresses
}

output "names" {
  description = "List of address resource names managed by this module (e.g. [\"gusw1-dev-fooapp-fe-0001-a-0001-ip\"])"
  value       = module.example.names
}

output "dns_fqdns" {
  description = "List of DNS fully qualified domain names registered in Cloud DNS.  (e.g. [\"gusw1-dev-fooapp-fe-0001-a-001.example.com\", \"gusw1-dev-fooapp-fe-0001-a-0002.example.com\"])"
  value       = module.example.dns_fqdns
}

output "reverse_dns_fqdns" {
  description = "List of reverse DNS PTR records registered in Cloud DNS."
  value       = module.example.reverse_dns_fqdns
}

output "forward_zone" {
  description = "The GCP name of the forward lookup DNS zone being used"
  value       = module.example.forward_zone
}

output "reverse_zone" {
  description = "The GCP name of the reverse lookup DNS zone being used"
  value       = module.example.reverse_zone
}

