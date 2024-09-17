# frozen_string_literal: true

module Renalware::Feeds
  describe PatientLocatorStrategies::NHSOrAnyAssigningAuthNumber do
    describe "#call" do
      [
        {
          patient_args: { nhs_number: "8016037658" },
          locator_args: { nhs_number: "8016037658", local_patient_id: "X" },
          found: true
        },
        {
          patient_args: { nhs_number: "1111111111" },
          locator_args: { nhs_number: "8016037658", local_patient_id: "X" },
          found: false
        },
        {
          patient_args: { nhs_number: nil, local_patient_id: "X" },
          locator_args: { nhs_number: "8016037658", local_patient_id: "X" },
          found: true
        },
        {
          patient_args: { nhs_number: nil, local_patient_id_2: "X" },
          locator_args: { nhs_number: "8016037658", local_patient_id: "X" },
          found: false
        },
        {
          patient_args: { nhs_number: nil, local_patient_id_2: "X" },
          locator_args: { nhs_number: "", local_patient_id_2: "X" },
          found: true
        },
        {
          patient_args: { nhs_number: "8016037658", local_patient_id_2: "X" },
          locator_args: { nhs_number: "8016037658", local_patient_id_2: "X" },
          found: true
        },
        {
          patient_args: { nhs_number: nil, local_patient_id_3: "X" },
          locator_args: { nhs_number: "", local_patient_id_3: "X" },
          found: true
        }
      ].each do |hash|
        it hash.to_s do
          patient_args = hash[:patient_args]
          patient = create(
            :patient,
            nhs_number: patient_args[:nhs_number],
            local_patient_id: patient_args[:local_patient_id] || Time.zone.now.to_i,
            local_patient_id_2: patient_args[:local_patient_id_2],
            local_patient_id_3: patient_args[:local_patient_id_3],
            local_patient_id_4: patient_args[:local_patient_id_4],
            local_patient_id_5: patient_args[:local_patient_id_5]
          )

          locator_args = hash[:locator_args]
          born_on = locator_args.delete(:born_on)
          patient_identification = instance_double(
            Renalware::Feeds::PatientIdentification,
            born_on: born_on,
            identifiers: locator_args
          )

          result = described_class.call(patient_identification: patient_identification)

          if hash[:found]
            expect(result).to eq(patient)
          else
            expect(result).to be_nil
          end
        end
      end
    end
  end
end
