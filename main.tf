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
  dns_args_missing         = "${var.enable_cloud_dns != "" && var.dns_domain == "" && var.dns_project == "" && var.dns_managed_zone == "" ? 1 : 0}"
  ptr_args_missing         = "${var.enable_reverse_dns != "" && var.dns_reverse_zone == "" ? 1 : 0}"
  dns_fqdns                = "${formatlist("%s.%s", var.dns_short_names, var.dns_domain)}"
  regional_addresses_count = "${var.global ? 0 : length(var.names)}"
  global_addresses_count   = "${var.global ? length(var.names) : 0}"
  dns_forward_record_count = "${var.enable_cloud_dns != "" ? length(local.dns_fqdns) : 0}"
  dns_reverse_record_count = "${var.enable_reverse_dns != "" ? length(local.dns_fqdns) : 0}"
  ip_addresses             = "${concat(google_compute_address.ip.*.address, google_compute_global_address.global_ip.*.address)}"
  ip_names                 = "${concat(google_compute_address.ip.*.name, google_compute_global_address.global_ip.*.name)}"
  dns_ptr_fqdns            = "${data.template_file.ptrs.*.rendered}"
}

resource "null_resource" "dns_args_missing" {
  count                                                                                                                                                                                     = "${local.dns_args_missing}"
  "ERROR: Variable `enable_cloud_dns` was passed to enable DNS registration. Please provide values for the `dns_domain`, `dns_project`, and `dns_managed_zone` input variables to continue" = true
}

resource "null_resource" "ptr_args_missing" {
  count                                                                                                                                                              = "${local.ptr_args_missing}"
  "ERROR: Variable `enable_reverse_dns` was passed to enable reverse DNS registration. Please provide a value for the `dns_reverse_zone` input variable to continue" = true
}

/******************************************
  Format reverse DNS entries - see https://github.com/hashicorp/terraform/issues/9404
 *****************************************/
data "template_file" "ptrs" {
  count = "${var.enable_reverse_dns != "" ? local.regional_addresses_count : 0}"

  template = "$${d}.$${c}.$${b}.$${a}.in-addr.arpa"

  vars {
    a = "${element(split(".", element(local.ip_addresses, count.index)), 0)}"
    b = "${element(split(".", element(local.ip_addresses, count.index)), 1)}"
    c = "${element(split(".", element(local.ip_addresses, count.index)), 2)}"
    d = "${element(split(".", element(local.ip_addresses, count.index)), 3)}"
  }
}

/******************************************
  IP address reservation
 *****************************************/
resource "google_compute_address" "ip" {
  count        = "${local.regional_addresses_count}"
  project      = "${var.project_id}"
  region       = "${var.region}"
  name         = "${element(var.names, count.index)}"
  address      = "${element(var.addresses, count.index)}"
  subnetwork   = "${var.subnetwork}"
  address_type = "${var.address_type}"
}

resource "google_compute_global_address" "global_ip" {
  count   = "${local.global_addresses_count}"
  project = "${var.project_id}"
  name    = "${element(var.names, count.index)}"
}

/******************************************
  Forward and reverse DNS entries - note the trailing dot in name
 *****************************************/
resource "google_dns_record_set" "ip" {
  count        = "${local.dns_forward_record_count}"
  name         = "${element(local.dns_fqdns, count.index)}."
  managed_zone = "${var.dns_managed_zone}"
  type         = "${var.dns_record_type}"
  ttl          = "${var.dns_ttl}"
  rrdatas      = ["${element(local.ip_addresses, count.index)}"]
  project      = "${var.dns_project}"
}

resource "google_dns_record_set" "ptr" {
  count        = "${local.dns_reverse_record_count}"
  name         = "${element(local.dns_ptr_fqdns, count.index)}."
  managed_zone = "${var.dns_reverse_zone}"
  type         = "PTR"
  ttl          = "${var.dns_ttl}"
  rrdatas      = ["${element(local.dns_fqdns, count.index)}."]
  project      = "${var.dns_project}"
}
