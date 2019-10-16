#!/bin/bash
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
set -u

# check for input variables
if [ $# -lt 2 ]; then
  echo
  echo "Usage: $0 <project id> <service account name>"
  echo
  echo "  project id (required)"
  echo "  service account name (required)"
  echo
  exit 1
fi


# Host project
echo "Verifying project..."
HOST_PROJECT="$(gcloud projects list --format="value(projectId)" --filter="$1")"

if [[ $HOST_PROJECT == "" ]];
then
  echo "The host project does not exist. Exiting."
  exit 1;
fi

# Service Account creation
SA_NAME="$2"
SA_ID="${SA_NAME}@${HOST_PROJECT}.iam.gserviceaccount.com"
STAGING_DIR="${PWD}"
KEY_FILE="${STAGING_DIR}/credentials.json"

echo "Creating service account..."
gcloud iam service-accounts \
    --project "${HOST_PROJECT}" create "${SA_NAME}" \
    --display-name "${SA_NAME}"

echo "Downloading key to credentials.json..."
gcloud iam service-accounts keys create "${KEY_FILE}" \
    --iam-account "${SA_ID}" \
    --user-output-enabled false

# Grant roles/dns.admin to the service account on the host project
echo "Adding role roles/dns.admin on project ${HOST_PROJECT} to ${SA_ID}..."
gcloud projects add-iam-policy-binding \
  "${HOST_PROJECT}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/dns.admin" \
  --user-output-enabled false

# Grant roles/compute.networkAdmin to the service account on the host project
echo "Adding role roles/compute.networkAdmin on project ${HOST_PROJECT} to ${SA_ID}..."
gcloud projects add-iam-policy-binding \
  "${HOST_PROJECT}" \
  --member="serviceAccount:${SA_ID}" \
  --role="roles/compute.networkAdmin" \
  --user-output-enabled false

# Enable required API's
echo "Enabling APIs..."
gcloud services enable \
  cloudresourcemanager.googleapis.com \
  compute.googleapis.com \
  dns.googleapis.com \
  --project "${HOST_PROJECT}"
