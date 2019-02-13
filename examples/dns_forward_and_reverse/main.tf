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

provider "google" {
  project = "${var.project_id}"
  region  = "${var.region}"
}

module "address" {
  source           = "../../"
  subnetwork       = "${var.subnetwork}"
  enable_cloud_dns = "true"
  dns_domain       = "${var.dns_domain}"
  dns_managed_zone = "${var.dns_managed_zone}"
  dns_reverse_zone = "${var.dns_reverse_zone}"
  dns_project      = "${var.dns_project}"
  names            = "${var.names}"
  dns_short_names  = "${var.dns_short_names}"
}
