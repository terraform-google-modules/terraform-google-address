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
  description = "The project ID to create the addresses in"
}

variable "region" {
  type        = string
  description = "The default region to create regional addresses in. May be overridden per address with the `region` attribute."
}

variable "addresses" {
  description = "A list of IP addresses to reserve, keyed by `name`. Each attribute left unset (`null`) falls back to the matching module-level variable when one exists. Set `address` to reserve a specific IP, leave it unset to let GCP pick one. Set `global` to true for a global address. `dns_short_names` registers forward DNS records for the address when `enable_cloud_dns` is set, and the first short name is used for the PTR record when `enable_reverse_dns` is set."
  type = list(object({
    name               = string
    address            = optional(string)
    description        = optional(string)
    region             = optional(string)
    global             = optional(bool, false)
    address_type       = optional(string)
    subnetwork         = optional(string)
    ip_version         = optional(string)
    labels             = optional(map(string))
    purpose            = optional(string)
    network_tier       = optional(string)
    prefix_length      = optional(number)
    enable_cloud_dns   = optional(bool)
    enable_reverse_dns = optional(bool)
    dns_short_names    = optional(list(string), [])
    dns_domain         = optional(string)
    dns_managed_zone   = optional(string)
    dns_reverse_zone   = optional(string)
    dns_record_type    = optional(string)
    dns_ttl            = optional(number)
    dns_project        = optional(string)
  }))

  validation {
    condition = alltrue([
      for addr in var.addresses : can(regex("^[a-z]([-a-z0-9]*[a-z0-9])?$", addr.name)) && length(addr.name) <= 63
    ])
    error_message = "Each name must be 1-63 chars, start with lowercase, and be RFC1035 compliant."
  }

  validation {
    condition     = length(distinct([for addr in var.addresses : addr.name])) == length(var.addresses)
    error_message = "Address names must be unique."
  }
}

variable "dns_project" {
  description = "The default project where DNS records will be configured. Falls back to `project_id` if unset."
  type        = string
  default     = ""
}

variable "dns_domain" {
  description = "The default domain to append to DNS short names when registering in Cloud DNS."
  type        = string
  default     = ""
}

variable "dns_ttl" {
  type        = number
  description = "The default DNS TTL in seconds for records created in Cloud DNS.  The default value should be used unless the application demands special handling."
  default     = 300
}

variable "dns_managed_zone" {
  type        = string
  description = "The default name of the managed zone to create records within.  This managed zone must exist in the host project."
  default     = ""
}

variable "dns_reverse_zone" {
  type        = string
  description = "The default name of the managed zone to create PTR records within.  This managed zone must exist in the host project."
  default     = ""
}

variable "dns_record_type" {
  type        = string
  description = "The default type of records to create in the managed zone.  (e.g. \"A\")"
  default     = "A"
}

variable "enable_cloud_dns" {
  description = "If set, register records in Cloud DNS for addresses that do not set their own `enable_cloud_dns` attribute."
  type        = bool
  default     = false
}

variable "enable_reverse_dns" {
  description = "If set, register reverse DNS PTR records in Cloud DNS for addresses that do not set their own `enable_reverse_dns` attribute."
  type        = bool
  default     = false
}

variable "subnetwork" {
  type        = string
  description = "The default subnet containing the addresses.  For EXTERNAL addresses use the empty string, \"\".  (e.g. \"projects/<project-name>/regions/<region-name>/subnetworks/<subnetwork-name>\")"
  default     = ""
}

variable "address_type" {
  type        = string
  description = "The default type of address to reserve, either \"INTERNAL\" or \"EXTERNAL\". If unspecified, defaults to \"INTERNAL\"."
  default     = "INTERNAL"
}

variable "purpose" {
  type        = string
  description = "The default purpose of the resource (GCE_ENDPOINT, SHARED_LOADBALANCER_VIP, VPC_PEERING, PRIVATE_SERVICE_CONNECT)."
  default     = "GCE_ENDPOINT"
}

variable "network_tier" {
  type        = string
  description = "The default networking tier used for configuring the addresses."
  default     = "PREMIUM"
}

variable "prefix_length" {
  type        = number
  description = "The default prefix length of the IP ranges."
  default     = 16
}

variable "ip_version" {
  type        = string
  description = "The default IP Version that will be used by the addresses."
  default     = "IPV4"
}

variable "labels" {
  type        = map(string)
  description = "The default labels to apply to the addresses."
  default     = {}
}
