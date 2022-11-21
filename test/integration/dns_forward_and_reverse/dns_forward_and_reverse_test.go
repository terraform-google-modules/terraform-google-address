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

package dns_forward_and_reverse

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestDnsForwardAndReverse(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		projectId := bpt.GetStringOutput("project_id")
		addresses := terraform.OutputList(t, bpt.GetTFOptions(), "addresses")
		name := [3]string{"dynamically-reserved-ip-030", "dynamically-reserved-ip-031", "dynamically-reserved-ip-032"}
		dnsFqdns := terraform.OutputList(t, bpt.GetTFOptions(), "dns_fqdns")
		reverseDnsFqdns := terraform.OutputList(t, bpt.GetTFOptions(), "reverse_dns_fqdns")
		forwardZone := bpt.GetStringOutput("forward_zone")
		reverseZone := bpt.GetStringOutput("reverse_zone")

		for index, element := range addresses {
			op := gcloud.Runf(t, fmt.Sprintf("compute addresses list --filter='%s' --project %s", element, projectId)).Array()[0].Get("name")
			assert.Contains(op.String(), name[index], "IP addresses Created")
		}

		for index, element := range dnsFqdns {
			op1 := gcloud.Runf(t, fmt.Sprintf("dns record-sets list --filter='%s' --zone=%s --project %s", element, forwardZone, projectId)).Array()[0].Get("rrdatas")
			assert.Contains(op1.String(), addresses[index], "Matches the FQDN to the correct IP address")
		}

		for index, element := range reverseDnsFqdns {
			op2 := gcloud.Runf(t, fmt.Sprintf("dns record-sets list --filter='%s' --zone=%s --project %s", element, reverseZone, projectId)).Array()[0].Get("rrdatas")
			assert.Contains(op2.String(), dnsFqdns[index], "Matches the FQDN to the correct IP address")
		}
	})

	bpt.Test()
}
