# frozen_string_literal: true

module Renalware
  module Pathology
    # rubocop:disable RSpec/VerifiedDoubles
    describe FindOrCreateObservationDescription do
      describe "#call" do
        let(:observation) {
          double(
            identifier: "I_DO_NOT_EXIST_CODE",
            name: "I_DO_NOT_EXIST_NAME",
            observed_at: "200911112026",
            value: "::value::",
            comment: "::comment::",
            cancelled: nil,
            units: ""
          )
        }

        context "when the observation_description does not exist" do
          it "creates it" do
            observation_desc = nil
            sender = create(:pathology_sender)
            svc = described_class.new(observation: observation, sender: sender)

            expect {
              observation_desc = svc.call
            }.to change(ObservationDescription, :count).by(1)

            expect(observation_desc).to have_attributes(
              code: "I_DO_NOT_EXIST_CODE",
              name: "I_DO_NOT_EXIST_NAME",
              created_by_sender: sender
            )
          end
        end

        context "when the observation_description exist and there are no obx mappings" do
          it "returns the observation_description" do
            original = create(
              :pathology_observation_description,
              code: "I_DO_NOT_EXIST_CODE",
              name: "I_DO_NOT_EXIST_NAME"
            )

            found = nil
            sender = create(:pathology_sender)
            svc = described_class.new(observation: observation, sender: sender)

            expect {
              found = svc.call
            }.not_to change(ObservationDescription, :count)

            expect(found).to eq(original)
          end
        end

        context "when the observation_description and obx_mapping exist" do
          context "when incoming obx differs but maps to a correct observaton_description" do
            it "returns the mapped observation_description" do
              allow(observation).to receive(:identifier).and_return("HB")
              sender = create(:pathology_sender)
              target_obs_desc = create(
                :pathology_observation_description,
                code: "HGB"
              )
              create(
                :pathology_obx_mapping,
                sender: sender,
                code_alias: "HB",
                observation_description: target_obs_desc
              )

              found_obs_desc = nil
              svc = described_class.new(observation: observation, sender: sender)

              expect {
                found_obs_desc = svc.call
              }.not_to change(ObservationDescription, :count)

              expect(found_obs_desc).to eq(target_obs_desc)
            end
          end
        end
      end
    end
    # rubocop:enable RSpec/VerifiedDoubles
  end
end
