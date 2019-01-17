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
  name = "ip-address-with-specific-ip"
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
  ip_cidr_range            = "10.12.0.0/24"
  network                  = "${google_compute_network.default.self_link}"
  region                   = "${var.region}"
  private_ip_google_access = true
}

module "address" {
  source     = "../../"
  subnetwork = "${google_compute_subnetwork.default.name}"
  names      = ["statically-reserved-ip-001"]
  addresses  = ["10.12.0.110"]
}
