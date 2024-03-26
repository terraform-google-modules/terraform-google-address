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

variable "addresses" {
  type = list(object({
    name               = string
    address            = optional(string, "")
    address_type       = optional(string, "INTERNAL")
    description        = optional(string, "")
    region             = optional(string, "")
    global             = optional(bool, false)
    subnetwork         = optional(string, "")
    ip_version         = optional(string, "")
    labels             = optional(map(string))
    purpose            = optional(string)
    enable_cloud_dns   = optional(bool, false)
    dns_short_name     = optional(string)
    dns_domain         = optional(string, "")
    dns_managed_zone   = optional(string, "")
    dns_record_type    = optional(string, "")
    dns_ttl            = optional(string, "")
    dns_project        = optional(string, "")
    enable_reverse_dns = optional(bool, false)
    dns_reverse_zone   = optional(string, "")
  }))
  description = "IP addresses"
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
  description = "The IP Version that will be used by addresses."
  default     = "IPV4"
}
