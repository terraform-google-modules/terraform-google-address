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

module "example" {
  source           = "../../../examples/dns_forward_example"
  project_id       = "${var.project_id}"
  region           = "${var.region}"
  credentials_path = "${local.credentials_path}"
  subnetwork       = "${google_compute_subnetwork.main.name}"
  dns_project      = "${var.project_id}"
  dns_domain       = "${local.domain}"
  dns_managed_zone = "${local.forward_zone}"

  names = [
    "dynamically-reserved-ip-020",
    "dynamically-reserved-ip-021",
    "dynamically-reserved-ip-022",
  ]

  dns_short_names = [
    "testip-021",
    "testip-022",
    "testip-023",
  ]
}
