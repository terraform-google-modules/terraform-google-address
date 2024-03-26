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

/******************************************
  Locals configuration and validation
 *****************************************/
locals {
  ip_addresses  = { for addr in merge(google_compute_address.ip, google_compute_global_address.global_ip) : addr.name => addr.address }
  ip_names      = [for addr in merge(google_compute_address.ip, google_compute_global_address.global_ip) : addr.name]
  self_links    = { for addr in merge(google_compute_address.ip, google_compute_global_address.global_ip) : addr.name => addr.self_link }
  split_ips     = { for addr in merge(google_compute_address.ip, google_compute_global_address.global_ip) : addr.name => split(".", addr.address) }
  dns_ptr_fqdns = { for addr_name, split_ip in local.split_ips : addr_name => ["${join(".", reverse(split_ip))}.in-addr.arpa"] }
}

/******************************************
  IP address reservation
 *****************************************/
resource "google_compute_address" "ip" {
  for_each     = { for addr in var.addresses : addr.name => addr if !addr.global }
  project      = var.project_id
  region       = each.value.region == "" ? var.region : each.value.region
  name         = each.value.name
  address      = each.value.address
  subnetwork   = each.value.address_type == "INTERNAL" ? each.value.subnetwork : null
  address_type = each.value.address_type == "" ? var.address_type : each.value.address_type
  purpose      = each.value.address_type == "INTERNAL" ? var.purpose : null
  network_tier = each.value.address_type == "INTERNAL" ? null : var.network_tier
  ip_version   = each.value.ip_version == "" ? var.ip_version : each.value.ip_version
  labels       = each.value.labels
}

resource "google_compute_global_address" "global_ip" {
  for_each      = { for addr in var.addresses : addr.name => addr if addr.global }
  project       = var.project_id
  name          = each.value.name
  address_type  = each.value.address_type
  address       = each.value.address
  network       = each.value.address_type == "EXTERNAL" ? null : each.value.subnetwork
  purpose       = each.value.address_type == "INTERNAL" ? "VPC_PEERING" : null
  prefix_length = each.value.address_type == "EXTERNAL" || (each.value.address_type == "INTERNAL" && each.value.purpose == "PRIVATE_SERVICE_CONNECT") ? null : var.prefix_length
  ip_version    = each.value.ip_version == "" ? var.ip_version : each.value.ip_version
}

/******************************************
  Forward and reverse DNS entries - note the trailing dot in name
 *****************************************/
resource "google_dns_record_set" "ip" {
  for_each     = { for addr in var.addresses : addr.name => addr if addr.enable_cloud_dns }
  name         = "${format("%s.%s", each.value.dns_short_name, each.value.dns_domain)}."
  managed_zone = each.value.dns_managed_zone == "" ? var.dns_managed_zone : each.value.dns_managed_zone
  type         = each.value.dns_record_type == "" ? var.dns_record_type : each.value.dns_record_type
  ttl          = each.value.dns_ttl == "" ? var.dns_ttl : each.value.dns_ttl
  rrdatas = [
    local.ip_addresses[each.key]
  ]
  project = each.value.dns_project == "" ? var.project_id : each.value.dns_project
}

resource "google_dns_record_set" "ptr" {
  for_each     = { for addr in var.addresses : addr.name => addr if addr.enable_reverse_dns }
  name         = "${local.dns_ptr_fqdns[each.key][0]}."
  managed_zone = each.value.dns_reverse_zone == "" ? var.dns_reverse_zone : each.value.dns_reverse_zone
  type         = "PTR"
  ttl          = each.value.dns_ttl == "" ? var.dns_ttl : each.value.dns_ttl
  rrdatas      = ["${format("%s.%s", each.value.dns_short_name, each.value.dns_domain)}."]
  project      = each.value.dns_project == "" ? var.project_id : each.value.dns_project
}
