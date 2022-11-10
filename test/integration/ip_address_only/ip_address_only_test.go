package ip_address_only

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestIpAddressOnly(t *testing.T) {
	bpt := tft.NewTFBlueprintTest(t)

	bpt.DefineVerify(func(assert *assert.Assertions) {
		bpt.DefaultVerify(assert)

		projectId := bpt.GetStringOutput("project_id")
		address := "10.13.0.2"
		name := "dynamically-assigned-ip-001"

		op := gcloud.Runf(t, fmt.Sprintf("compute addresses list --filter='%s' --project %s", address, projectId)).Array()[0].Get("name")
		assert.Contains(op.String(), name, "IP addresses Created")
	})

	bpt.Test()
}
