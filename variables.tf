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

variable "project_id" {
  type        = string
  description = "The project ID to create the address in"
}

variable "region" {
  type        = string
  description = "The region to create the address in"
}

variable "names" {
  description = "A list of IP address resource names to create.  This is the GCP resource name and not the associated hostname of the IP address.  Existing resource names may be found with `gcloud compute addresses list` (e.g. [\"gusw1-dev-fooapp-fe-0001-a-001-ip\"])"
  type        = list(string)
  default     = []
}

variable "addresses" {
  description = "A list of IP addresses to create.  GCP will reserve unreserved addresses if given the value \"\".  If multiple names are given the default value is sufficient to have multiple addresses automatically picked for each name."
  type        = list(string)
  default     = [""]
}

variable "global" {
  description = "The scope in which the address should live. If set to true, the IP address will be globally scoped. Defaults to false, i.e. regionally scoped. When set to true, do not provide a subnetwork."
  type        = bool
  default     = false
}

variable "dns_short_names" {
  description = "A list of DNS short names to register within Cloud DNS.  Names corresponding to addresses must align by their list index position in the two input variables, `names` and `dns_short_names`.  If an empty list, no domain names are registered.  Multiple names may be registered to the same address by passing a single element list to names and multiple elements to dns_short_names.  (e.g. [\"gusw1-dev-fooapp-fe-0001-a-001\"])"
  type        = list(string)
  default     = []
}

variable "dns_domain" {
  description = "The domain to append to DNS short names when registering in Cloud DNS."
  type        = string
  default     = ""
}

variable "dns_project" {
  description = "The project where DNS A records will be configured."
  type        = string
  default     = ""
}

variable "dns_ttl" {
  type        = number
  description = "The DNS TTL in seconds for records created in Cloud DNS.  The default value should be used unless the application demands special handling."
  default     = 300
}

variable "dns_managed_zone" {
  type        = string
  description = "The name of the managed zone to create records within.  This managed zone must exist in the host project."
  default     = ""
}

variable "dns_reverse_zone" {
  type        = string
  description = "The name of the managed zone to create PTR records within.  This managed zone must exist in the host project."
  default     = ""
}

variable "dns_record_type" {
  type        = string
  description = "The type of records to create in the managed zone.  (e.g. \"A\")"
  default     = "A"
}

variable "subnetwork" {
  type        = string
  description = "The subnet containing the address.  For EXTERNAL addresses use the empty string, \"\".  (e.g. \"projects/<project-name>/regions/<region-name>/subnetworks/<subnetwork-name>\")"
  default     = ""
}

variable "address_type" {
  type        = string
  description = "The type of address to reserve, either \"INTERNAL\" or \"EXTERNAL\". If unspecified, defaults to \"INTERNAL\"."
  default     = "INTERNAL"
}

variable "enable_cloud_dns" {
  description = "If a value is set, register records in Cloud DNS."
  type        = bool
  default     = false
}

variable "enable_reverse_dns" {
  description = "If a value is set, register reverse DNS PTR records in Cloud DNS in the managed zone specified by dns_reverse_zone"
  type        = bool
  default     = false
}

variable "purpose" {
  type        = string
  description = "The purpose of the resource(GCE_ENDPOINT, SHARED_LOADBALANCER_VIP, VPC_PEERING)."
  default     = "GCE_ENDPOINT"
}

variable "network_tier" {
  type        = string
  description = "The networking tier used for configuring this address."
  default     = "PREMIUM"
}

variable "prefix_length" {
  type        = number
  description = "The prefix length of the IP range."
  default     = 16
}

variable "ip_version" {
  type        = string
  description = "The IP Version that will be used by this address."
  default     = "IPV4"
}
