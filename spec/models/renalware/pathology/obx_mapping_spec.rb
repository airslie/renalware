module Renalware
  module Pathology
    describe OBXMapping do
      it_behaves_like "an Accountable model"

      it :aggregate_failures do
        is_expected.to be_versioned
        is_expected.to belong_to(:sender)
        is_expected.to belong_to(:observation_description)

        is_expected.to validate_presence_of(:code_alias)
        is_expected.to validate_presence_of(:sender)
        is_expected.to validate_presence_of(:observation_description)
      end

      describe "uniqueness" do
        subject {
          described_class.create!(
            code_alias: "A",
            observation_description: create(:pathology_observation_description),
            sender: create(:pathology_sender)
          )
        }

        it {
          is_expected.to validate_uniqueness_of(:code_alias).scoped_to(:sender_id)
        }
      end

      # rubocop:disable Layout/CaseIndentation, Layout/EndAlignment
      describe "#observation_description_for" do
        let(:sender) { create(:pathology_sender) }
        let(:sender_other) { create(:pathology_sender) }
        let(:hb) { create(:pathology_observation_description, code: "HB") }
        let(:hgb) { create(:pathology_observation_description, code: "HGB") }
        let(:plt) { create(:pathology_observation_description, code: "PLT") }
        let(:pot) { create(:pathology_observation_description, code: "POT") }
        let(:k) { create(:pathology_observation_description, code: "K") }

        [
          # Will be a direct match on the HGB observation description
          {
            before: %i(hgb plt pot),
            incoming_code: "HGB",
            mappings: [],
            resolved_observation_description: "HGB"
          },
          # Will be a direct match on the PLT observation description
          {
            before: %i(hgb plt pot),
            incoming_code: "PLT",
            mappings: [],
            resolved_observation_description: "PLT"
          },
          # Maps HB to HGB. By creating hb before hgb it will have a lower id in the table
          # Which should not be significant but need to test in case it affects the ordering
          # and which obs desc floats to the top.
          {
            before: %i(hb hgb plt pot),
            incoming_code: "HB",
            mappings: [
              { sender: "s2", code_alias: "ABC", maps_to: "PLT" },
              { sender: "s1", code_alias: "HB", maps_to: "HGB" }, # target
              { sender: "s1", code_alias: "XZY", maps_to: "PLT" }
            ],
            resolved_observation_description: "HGB"
          },
          {
            before: %i(k hgb plt pot),
            incoming_code: "K",
            mappings: [
              { sender: "s1", code_alias: "K", maps_to: "POT" }
            ],
            resolved_observation_description: "POT"
          },
          # Incoming code not found
          {
            before: %i(hgb plt pot),
            incoming_code: "HB",
            mappings: [
              { sender: "s1", code_alias: "HB1", maps_to: "HGB" }
            ],
            resolved_observation_description: nil # miss
          }
        ].each do |testcase|
          it testcase do
            # Create the let local vars in the requested order - could be significant
            testcase[:before].each { |var| send(var) }

            # Create the mappings defined in the hash. Note we can't use variables outside of
            # the it block so have to map s1 to the sender var and HGB to the hgb var etc
            # (tried using procs but that did not work).
            testcase[:mappings].each do |mapping|
              snd = case mapping[:sender]
                when "s1" then sender
                when "s2" then sender_other
              end

              maps_to = case mapping[:maps_to]
                when "HGB" then hgb
                when "PLT" then plt
                when "POT" then pot
              end

              create(
                :pathology_obx_mapping,
                sender: snd,
                code_alias: mapping[:code_alias],
                observation_description: maps_to
              )
            end

            resolved_observation_description = case testcase[:resolved_observation_description]
                                              when "HGB" then hgb
                                              when "PLT" then plt
                                              when "POT" then pot
                                              end

            expect(
              described_class.observation_description_for(
                sender: sender,
                code: testcase[:incoming_code]
              )
            ).to eq(resolved_observation_description)
          end
        end
        # rubocop:enable Layout/CaseIndentation, Layout/EndAlignment
      end
    end
  end
end
