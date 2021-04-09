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

locals {
  randomized_name = "cft-address-test-${random_string.suffix.result}"
  domain          = "justfortesting.local"
  forward_zone    = "forward-cft-address-test"
  reverse_zone    = "reverse-cft-address-test"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

provider "google" {
  project = var.project_id
}

resource "google_compute_network" "main" {
  name                    = local.randomized_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name                     = local.randomized_name
  ip_cidr_range            = "10.10.0.0/24"
  region                   = var.region
  private_ip_google_access = true
  network                  = google_compute_network.main.self_link
}

resource "google_dns_managed_zone" "forward" {
  name          = local.forward_zone
  dns_name      = "${local.domain}."
  description   = "DNS forward lookup zone example"
  force_destroy = true
}

resource "google_dns_managed_zone" "reverse" {
  name          = local.reverse_zone
  dns_name      = "10.10.in-addr.arpa."
  description   = "DNS reverse lookup zone example"
  force_destroy = true
}

