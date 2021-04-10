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
  int_required_roles = [
    "roles/compute.networkAdmin",
    "roles/dns.admin",
    "roles/iam.serviceAccountUser",
  ]

}

resource "random_id" "random_suffix" {
  byte_length = 2
}

resource "google_service_account" "address" {
  project      = module.address_module.project_id
  account_id   = "ci-address-${random_id.random_suffix.hex}"
  display_name = "ci-address"
}

resource "google_project_iam_member" "address" {
  count   = length(local.int_required_roles)
  project = module.address_module.project_id
  role    = local.int_required_roles[count.index]
  member  = "serviceAccount:${google_service_account.address.email}"
}

resource "google_service_account_key" "address" {
  service_account_id = google_service_account.address.id
}
