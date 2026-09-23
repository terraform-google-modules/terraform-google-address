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
  # Addresses keyed by name, with unset per-address attributes falling back
  # to the module-level defaults.
  addresses = {
    for addr in var.addresses : addr.name => merge(addr, {
      region             = addr.region != null ? addr.region : var.region
      address_type       = addr.address_type != null ? addr.address_type : var.address_type
      subnetwork         = addr.subnetwork != null ? addr.subnetwork : var.subnetwork
      ip_version         = addr.ip_version != null ? addr.ip_version : var.ip_version
      labels             = addr.labels != null ? addr.labels : var.labels
      purpose            = addr.purpose != null ? addr.purpose : var.purpose
      network_tier       = addr.network_tier != null ? addr.network_tier : var.network_tier
      prefix_length      = addr.prefix_length != null ? addr.prefix_length : var.prefix_length
      enable_cloud_dns   = addr.enable_cloud_dns != null ? addr.enable_cloud_dns : var.enable_cloud_dns
      enable_reverse_dns = addr.enable_reverse_dns != null ? addr.enable_reverse_dns : var.enable_reverse_dns
      dns_domain         = addr.dns_domain != null ? addr.dns_domain : var.dns_domain
      dns_managed_zone   = addr.dns_managed_zone != null ? addr.dns_managed_zone : var.dns_managed_zone
      dns_reverse_zone   = addr.dns_reverse_zone != null ? addr.dns_reverse_zone : var.dns_reverse_zone
      dns_record_type    = addr.dns_record_type != null ? addr.dns_record_type : var.dns_record_type
      dns_ttl            = addr.dns_ttl != null ? addr.dns_ttl : var.dns_ttl
      dns_project        = coalesce(addr.dns_project, var.dns_project, var.project_id)
    })
  }

  regional_addresses = { for name, addr in local.addresses : name => addr if !addr.global }
  global_addresses   = { for name, addr in local.addresses : name => addr if addr.global }

  ip_addresses = {
    for name, addr in local.addresses :
    name => addr.global ? google_compute_global_address.global_ip[name].address : google_compute_address.ip[name].address
  }
  self_links = {
    for name, addr in local.addresses :
    name => addr.global ? google_compute_global_address.global_ip[name].self_link : google_compute_address.ip[name].self_link
  }

  dns_fqdns = {
    for name, addr in local.addresses :
    name => [for short_name in addr.dns_short_names : format("%s.%s", short_name, addr.dns_domain)]
  }

  # One forward record per (address, dns short name) pair. Keyed by
  # "<address name>/<short name>" so keys are known at plan time even when
  # the DNS domain is computed.
  dns_forward_records = merge([
    for name, addr in local.addresses : {
      for index, short_name in addr.dns_short_names :
      "${name}/${short_name}" => merge(addr, {
        address_name = name
        fqdn         = local.dns_fqdns[name][index]
      })
    } if addr.enable_cloud_dns
  ]...)

  /******************************************
  Format reverse DNS entries - see https://github.com/hashicorp/terraform/issues/9404
  *****************************************/
  dns_ptr_fqdns = {
    for name, addr in local.addresses :
    name => format("%s.in-addr.arpa", join(".", reverse(split(".", local.ip_addresses[name]))))
    if addr.enable_reverse_dns
  }
}

/******************************************
  IP address reservation
 *****************************************/
resource "google_compute_address" "ip" {
  for_each     = local.regional_addresses
  project      = var.project_id
  region       = each.value.region
  name         = each.key
  address      = each.value.address
  subnetwork   = each.value.address_type == "INTERNAL" ? each.value.subnetwork : null
  address_type = each.value.address_type
  purpose      = each.value.address_type == "INTERNAL" ? each.value.purpose : null
  network_tier = each.value.address_type == "INTERNAL" ? null : each.value.network_tier
  labels       = each.value.labels
  description  = each.value.description
}

resource "google_compute_global_address" "global_ip" {
  for_each      = local.global_addresses
  project       = var.project_id
  name          = each.key
  address_type  = each.value.address_type
  address       = each.value.address
  network       = each.value.address_type == "EXTERNAL" ? null : each.value.subnetwork
  purpose       = each.value.address_type == "INTERNAL" ? (each.value.purpose == "PRIVATE_SERVICE_CONNECT" ? "PRIVATE_SERVICE_CONNECT" : "VPC_PEERING") : null
  prefix_length = each.value.address_type == "EXTERNAL" || (each.value.address_type == "INTERNAL" && each.value.purpose == "PRIVATE_SERVICE_CONNECT") ? null : each.value.prefix_length
  ip_version    = each.value.ip_version
  description   = each.value.description
}

/******************************************
  Forward and reverse DNS entries - note the trailing dot in name
 *****************************************/
resource "google_dns_record_set" "ip" {
  for_each     = local.dns_forward_records
  name         = "${each.value.fqdn}."
  managed_zone = each.value.dns_managed_zone
  type         = each.value.dns_record_type
  ttl          = each.value.dns_ttl
  rrdatas      = [local.ip_addresses[each.value.address_name]]
  project      = each.value.dns_project
}

resource "google_dns_record_set" "ptr" {
  for_each     = local.dns_ptr_fqdns
  name         = "${each.value}."
  managed_zone = local.addresses[each.key].dns_reverse_zone
  type         = "PTR"
  ttl          = local.addresses[each.key].dns_ttl
  rrdatas      = ["${local.dns_fqdns[each.key][0]}."]
  project      = local.addresses[each.key].dns_project
}
