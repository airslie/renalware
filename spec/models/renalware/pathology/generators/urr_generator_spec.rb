module Renalware
  module Pathology
    describe Generators::UrrGenerator do
      let(:patient) { create(:pathology_patient) }
      let(:obr_desc) { create(:pathology_request_description, code: "UE") }
      let(:obx_desc_pre_urea) { create(:pathology_observation_description, code: "URE") }
      let(:obx_desc_post_urea) { create(:pathology_observation_description, code: "P_URE") }
      let(:obx_desc_urr) { create(:pathology_observation_description, code: "URR") }
      let(:datetime) { DateTime.parse("2001-01-01 14:00:00") }

      def create_pre_urea(observed_at, value)
        create(
          :pathology_observation,
          description: obx_desc_pre_urea,
          observed_at: observed_at,
          request: create(:pathology_observation_request, description: obr_desc, patient: patient),
          result: value
        )
      end

      def create_post_urea(obr, observed_at, value)
        create(
          :pathology_observation,
          description: obx_desc_post_urea,
          observed_at: observed_at,
          result: value,
          request: obr
        )
      end

      before do
        obx_desc_urr
        Renalware.configure do |config|
          config.pathology_hours_to_search_behind_for_pre_ure_result = 6
          config.pathology_hours_to_search_ahead_for_pre_ure_result = 4
        end
      end

      describe "looks for a post-HD urea eg P_URE and returns this + the closest pre-hd Urea" do
        [
          {
            post_urea: {
              observed_at: ->(dt) { dt },
              value: 10
            },
            pre_urea: [
              {
                observed_at: ->(dt) { dt - 1.hour },
                value: 20,
                target: true
              },
              {
                observed_at: ->(dt) { dt - 2.hours },
                value: 30
              },
              {
                observed_at: ->(dt) { dt + 61.minutes },
                value: 30
              }
            ],
            expected_observation_count: 2, # URR and Kt/V
            expected_urr: 50, # post: 10 pre: 20
            expected_ktv: 0.69
          },
          {
            post_urea: {
              observed_at: ->(dt) { dt },
              value: 11 # bigger not smaller than pre, so will not result in a urr
            },
            pre_urea: [
              {
                observed_at: ->(dt) { dt - 1.hour },
                value: 10
              }
            ],
            expected_observation_count: 0,
            expected_urr: 0
          },
          {
            post_urea: {
              observed_at: ->(dt) { dt },
              value: 10
            },
            pre_urea: [
              {
                observed_at: ->(dt) { dt - 7.hours }, # outside the window
                value: 20,
                target: true
              },
              {
                observed_at: ->(dt) { dt + 5.hours }, # outside the window
                value: 30
              }
            ],
            expected_observation_count: 0,
            expected_urr: 0
          }
        ].each do |test|
          it do
            obr = create(:pathology_observation_request, description: obr_desc, patient: patient)
            create_post_urea(
              obr,
              test[:post_urea][:observed_at].call(datetime),
              test[:post_urea][:value]
            )

            test[:pre_urea].each do |pre|
              create_pre_urea(
                pre[:observed_at].call(datetime),
                pre[:value]
              )
            end

            expect {
              described_class.call
            }.to change(Observation, :count).by(test[:expected_observation_count])

            if test[:expected_observation_count] > 0
              urr = patient.observations.where(description: obx_desc_urr).last
              expect(urr.nresult).to eq(test[:expected_urr])
              expect(urr.reload.calculation_sources.count).to eq(2)

              # The Kt/V OBX will have been created for us as it it not exists before
              obx_desc_ktv = Renalware::Pathology::ObservationDescription.find_by(code: "Kt/V")
              expect(obx_desc_ktv.name).to eq("Simple non-dialysis Kt/V")

              ktv = patient.observations.where(description: obx_desc_ktv).last
              expect(ktv.nresult).to eq(test[:expected_ktv])
              expect(ktv.calculation_sources.count).to eq(2)
            else
              expect(Pathology::CalculationSource.count).to eq(0)
            end

            # Check that once the URR is created, it does not re-create it.
            expect { described_class.call }.not_to change(Observation, :count)
          end
        end
      end
    end
  end
end
