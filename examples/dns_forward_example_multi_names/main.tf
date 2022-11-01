/**
 * Copyright 2022 Google LLC
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
  domain          = "justfortestingmultinames-${random_string.suffix.result}.local"
  forward_zone    = "forward-example-multinames"
  names = [
    "dynamically-reserved-ip-040",
  ]

  dns_short_names = [
    "testip-041",
    "testip-042",
    "testip-043",
  ]
}

module "address" {
  source           = "../../"
  project_id       = var.project_id
  region           = var.region
  enable_cloud_dns = true
  dns_domain       = local.domain
  dns_managed_zone = google_dns_managed_zone.forward.name
  dns_project      = var.project_id
  names            = local.names
  dns_short_names  = local.dns_short_names
  address_type     = "EXTERNAL"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "google_dns_managed_zone" "forward" {
  name          = local.forward_zone
  dns_name      = "${local.domain}."
  description   = "DNS forward lookup zone example"
  force_destroy = true
  project       = var.project_id
}
