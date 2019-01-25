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
credentials_path = attribute('credentials_path')
names            = attribute('names')
addresses        = attribute('addresses')

ENV['CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE'] = credentials_path

control "ip-address-only" do
  title "Address module - dynamic IP address configuration"

  describe command("gcloud projects describe #{project_id}") do
    its('exit_status') { should be 0 }
    its('stderr') { should eq '' }
  end

  addresses.each_with_index do |ip_address, index|
    describe command("gcloud compute addresses list --project #{project_id}  --format='json' --filter=address:#{ip_address}") do
      its('exit_status') { should be 0 }
      its('stderr') { should eq '' }

      let(:attributes) do
        if subject.exit_status == 0
          JSON.parse(subject.stdout, symbolize_names: true)
        else
          {}
        end
      end

      it "lists all reserved IP addresses" do
        expect(attributes.first).to include(
          name: "#{names[index]}"
        )
      end
    end
  end
end
