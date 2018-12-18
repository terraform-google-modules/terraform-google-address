# Copyright 2018 Google LLC
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

project_id       = attribute('project_id')
region           = attribute('region')
credentials_path = attribute('credentials_path')

ENV['CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE'] = File.absolute_path(
  credentials_path,
  File.join(__dir__, "../../../../examples/ip_address_with_specific_ip"))

control "ip-address-with-specific-ip" do
  title "Address module IP address only configuration"

  describe command("gcloud projects describe #{project_id}") do
    its('exit_status') { should be 0 }
    its('stderr') { should eq '' }
  end

  describe command("gcloud compute addresses list --project #{project_id} --format='json' --filter=name:statically-reserved-ip-001") do
    its('exit_status') { should be 0 }
    its('stderr') { should eq '' }

    let(:attributes) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout, symbolize_names: true)
      else
        {}
      end
    end

    it "lists a specific IP address" do
      expect(attributes.first).to include(address: "10.12.0.110")
    end
  end
end
