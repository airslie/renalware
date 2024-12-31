module Renalware
  module Pathology
    describe KFRE::Listener do
      subject(:listener) { described_class.new }

      let(:acr) { 300 } # > 300 = severely increased
      let(:local_patient_id) { "Z999990" }
      let(:dob) { "2015-04-01" }
      let(:observation_datetime) { "200911111841" }
      let(:patient) do
        create(:pathology_patient,
               local_patient_id: local_patient_id,
               born_on: Time.zone.today - 34.years) do |pat|
          create(
            :modality,
            started_on: Date.parse(dob),
            patient: pat,
            description: create(:modality_description, :aki)
          )
        end
      end

      before do
        Renalware.config.hl7_patient_locator_strategy[:oru] = :simple
        create(:pathology_lab, :unknown)
        create(:user, username: Renalware::SystemUser.username)
      end

      def pid(
        born_on: "20000101",
        nhs_number: nil,
        internal_id: nil
      )
        instance_double(
          Renalware::Feeds::PatientIdentification,
          nhs_number: patient.local_patient_id,
          internal_id: internal_id,
          born_on: born_on,
          identifiers: {
            nhs_number: nhs_number,
            local_patient_id: internal_id
          }.compact_blank
        )
      end

      describe "KFRE generation" do
        describe "#oru_message_arrived" do
          context "when the message does not contain an ACR result" do
            it "does not create a KFRE" do
              hl7_message = instance_double(
                Renalware::Feeds::HL7Message,
                observation_requests: []
              )

              expect {
                described_class.new.oru_message_arrived(hl7_message: hl7_message)
              }.not_to change(Renalware::Pathology::Observation, :count)
            end
          end

          context "when the message contains ACR result" do
            context "when the patient has no recent egfr" do
              it "does not create a KFRE" do
                hl7_message = instance_double(
                  Renalware::Feeds::HL7Message,
                  patient_identification: pid(internal_id: patient.local_patient_id),
                  observation_requests: [
                    instance_double(
                      Renalware::Feeds::HL7Message::ObservationRequest,
                      identifier: "SOME_OBR",
                      name: "SOME_OBR",
                      ordering_provider_name: "::name::",
                      placer_order_number: "::pcs code::",
                      filler_order_number: "::fillernum::",
                      observed_at: observation_datetime,
                      observations: [
                        instance_double(
                          Renalware::Feeds::HL7Message::Observation,
                          identifier: "ACR",
                          name: "ACR",
                          observed_at: observation_datetime,
                          value: "10",
                          comment: "",
                          cancelled: nil,
                          units: "mg"
                        )
                      ]
                    )
                  ]
                )

                expect {
                  described_class.new.oru_message_arrived(hl7_message: hl7_message)
                }.not_to change(Renalware::Pathology::Observation, :count)
              end
            end

            # rubocop:disable RSpec/ExampleLength
            context "when the patient has an egfr" do
              it "creates 5 and 2 yr KFREs" do
                # Creating an EGFR here will cause the results to be inserted into
                # patient.current_observation_set and we use this later, accessing it as
                # patient.current_observation_set.values.egrf_result
                create(
                  :pathology_observation,
                  description: create(:pathology_observation_description, code: "EGFR"),
                  request: create(:pathology_observation_request, patient: patient),
                  result: "10"
                )

                hl7_message = instance_double(
                  Renalware::Feeds::HL7Message,
                  patient_identification: pid(internal_id: patient.local_patient_id),
                  observation_requests: [
                    instance_double(
                      Renalware::Feeds::HL7Message::ObservationRequest,
                      identifier: "SOME_OBR",
                      name: "SOME_OBR",
                      ordering_provider_name: "::name::",
                      placer_order_number: "::pcs code::",
                      filler_order_number: "::fillernum::",
                      observed_at: observation_datetime,
                      observations: [
                        instance_double(
                          Renalware::Feeds::HL7Message::Observation,
                          identifier: "ACR",
                          name: "ACR",
                          observed_at: observation_datetime,
                          value: "10",
                          comment: "",
                          cancelled: nil,
                          units: "mg"
                        )
                      ]
                    )
                  ]
                )

                freeze_time do
                  allow(KFRE::CalculateKFRE)
                    .to receive(:call)
                    .and_return(KFRE::Result.new(yr2: 10.1, yr5: 20.2))

                  expect {
                    described_class.new.oru_message_arrived(hl7_message: hl7_message)
                  }.to change(Renalware::Pathology::Observation, :count).by(2)

                  expect(KFRE::CalculateKFRE)
                    .to have_received(:call)
                    .with(acr: 10.0, age: 34, egfr: "10", sex: "M")

                  patient.reload

                  # Requested and observed at timestamps should match the acr datetime
                  expected_date_time = Time.zone.parse(observation_datetime)

                  kfre_obr = patient.observation_requests.order(created_at: :desc).last
                  expect(kfre_obr).to have_attributes(requested_at: expected_date_time)
                  expect(kfre_obr.description.code).to eq("KFRE")

                  expect(kfre_obr.observations.count).to eq(2)

                  kfre_obx = kfre_obr.observations.detect do |obx|
                    obx.description.code == Renalware.config.pathology_kfre_2y_obx_code
                  end
                  expect(kfre_obx).to have_attributes(
                    result: "10.1", # TODO
                    observed_at: expected_date_time
                  )

                  kfre_obx = kfre_obr.observations.detect do |obx|
                    obx.description.code == Renalware.config.pathology_kfre_5y_obx_code
                  end
                  expect(kfre_obx).to have_attributes(
                    result: "20.2",
                    observed_at: expected_date_time
                  )
                end
              end
            end
            # rubocop:enable RSpec/ExampleLength
          end
        end
      end
    end
  end
end
