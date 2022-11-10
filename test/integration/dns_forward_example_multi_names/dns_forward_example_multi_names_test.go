// Copyright 2022 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package dns_forward_example_multi_names

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestDnsForwardExampleMultiNames(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		projectId := bpt.GetStringOutput("project_id")
		addresses := terraform.OutputList(t, bpt.GetTFOptions(), "addresses")
		names := terraform.OutputList(t, bpt.GetTFOptions(), "names")
		dnsFqdns := terraform.OutputList(t, bpt.GetTFOptions(), "dns_fqdns")
		forwardZone := bpt.GetStringOutput("forward_zone")

		for index, element := range addresses {
			op := gcloud.Runf(t, fmt.Sprintf("compute addresses list --filter='%s' --project %s", element, projectId)).Array()[0].Get("name")
			assert.Contains(op.String(), names[index], "IP addresses Created")
		}

		for _, element := range dnsFqdns {
			op1 := gcloud.Runf(t, fmt.Sprintf("dns record-sets list --filter='%s' --zone=%s --project %s", element, forwardZone, projectId)).Array()[0].Get("rrdatas")
			assert.Contains(op1.String(), addresses[0], "Matches the FQDN to the correct IP address")
		}
	})

	bpt.Test()
}
