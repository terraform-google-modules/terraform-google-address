/**
 * Copyright 2018 Google LLC
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

locals {
  name         = "dns-forward-and-reverse"
  reverse_name = "reverse"
}

provider "google" {
  credentials = "${file(var.credentials_path)}"
  project     = "${var.project_id}"
  region      = "${var.region}"
}

resource "google_compute_network" "default" {
  name                    = "${local.name}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = "${local.name}"
  ip_cidr_range            = "10.14.0.0/24"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = true
}

resource "google_dns_managed_zone" "forward" {
  name        = "${local.name}"
  dns_name    = "${var.dns_domain}."
  description = "DNS forward lookup zone example"
}

resource "google_dns_managed_zone" "reverse" {
  name        = "${local.reverse_name}"
  dns_name    = "14.10.in-addr.arpa."
  description = "DNS reverse lookup zone example"
}

module "address" {
  source             = "../../"
  subnetwork         = "${google_compute_subnetwork.default.name}"
  enable_cloud_dns   = "true"
  enable_reverse_dns = "true"
  dns_domain         = "${var.dns_domain}"
  dns_managed_zone   = "${local.name}"
  dns_reverse_zone   = "${local.reverse_name}"
  dns_project        = "${var.project_id}"

  names = [
    "dynamically-reserved-ip-030",
    "dynamically-reserved-ip-031",
    "dynamically-reserved-ip-032",
  ]

  dns_short_names = [
    "testip-031",
    "testip-032",
    "testip-033",
  ]
}
