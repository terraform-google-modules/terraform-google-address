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

# Entry point for CI Integration Tests.  This script is expected to be run
# inside the same docker image specified in the CI Pipeline definition.

# Always clean up.
DELETE_AT_EXIT="$(mktemp -d)"

finish() {
  echo 'BEGIN: finish() trap handler' >&2
  # There is a dependency issue with the integration tests - a DNS zone is
  # being created but the module also creates DNS entries within the zone. GCP
  # will not let you delete a zone without deleting all the entries first, and
  # the way the module is setup makes it difficult to setup that dependency.
  # Because of that reason, `kitchen destroy` needs to be run twice: first to
  # take care of the zone entries (which will produce an error), and a second
  # time to get rid of the zone.
  set +e
  bundle exec kitchen destroy
  bundle exec kitchen destroy
  [[ -d "${DELETE_AT_EXIT}" ]] && rm -rf "${DELETE_AT_EXIT}"
  echo 'END: finish() trap handler' >&2
}

main() {
  set -eu
  # Setup trap handler to auto-cleanup
  trap finish EXIT
  set -x
  # Execute the test lifecycle
  bundle install
  bundle exec kitchen create
  bundle exec kitchen converge
  bundle exec kitchen converge
  bundle exec kitchen verify
}

# if script is being executed and not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
