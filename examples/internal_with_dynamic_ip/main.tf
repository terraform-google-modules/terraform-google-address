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

// We declare 'region' because it is not defined elsewhere in this example.
// We DO NOT declare 'project_id' because it IS defined elsewhere.
variable "region" {
  description = "The region to host the network."
  default     = "asia-east1"
}

// Create the VPC network
resource "google_compute_network" "test_net" {
  name                    = "cft-test-net-internal-ip"
  auto_create_subnetworks = false
  project                 = var.project_id
}

// Create the 'my-subnet' subnetwork
resource "google_compute_subnetwork" "test_subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.10.10.0/24"
  region        = var.region
  network       = google_compute_network.test_net.self_link
  project       = var.project_id
}

module "address" {
  source     = "terraform-google-modules/address/google"
  project_id = var.project_id
  region     = var.region
  subnetwork = google_compute_subnetwork.test_subnet.self_link
  names      = ["internal-address1", "internal-address2"]
}
