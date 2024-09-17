# frozen_string_literal: true

module Renalware::Feeds
  describe PatientLocatorStrategies::DobAndAnyNHSOrAssigningAuthNumber do
    describe "#call" do
      [
        {
          patient_args: {
            born_on: "2000-01-01", nhs_number: "8016037658", local_patient_id: "123"
          },
          locator_args: {
            born_on: "2000-01-01", nhs_number: "8016037658", local_patient_id: "123"
          },
          found: true
        },
        {
          patient_args: { born_on: "2000-01-01", nhs_number: "8016037658" },
          locator_args: { born_on: "2000-01-01", nhs_number: "8016037658", local_patient_id: "X" },
          found: true
        },
        {
          patient_args: { born_on: "1900-01-01", nhs_number: "5928173695" },
          locator_args: { born_on: "2000-01-01", nhs_number: "5928173695" },
          found: false,
          log_close_match: true
        },
        {
          patient_args: { born_on: "2000-01-01", nhs_number: "9000386780" },
          locator_args: { born_on: "2000-01-01", nhs_number: "XXX" },
          found: false
        },
        {
          patient_args: { born_on: "2000-01-01", local_patient_id: "12345" },
          locator_args: { born_on: "2000-01-01", local_patient_id: nil },
          found: false
        },
        {
          patient_args: { born_on: "2000-01-01", local_patient_id: "123456" },
          locator_args: { born_on: "2000-01-01", local_patient_id: "123456" },
          found: true
        },
        {
          patient_args: { born_on: "2000-01-01", local_patient_id_2: "1234567" },
          locator_args: { born_on: "2000-01-01", local_patient_id_2: "1234567" },
          found: true
        },
        {
          patient_args: { born_on: "2000-01-01", local_patient_id_3: "12345678" },
          locator_args: { born_on: "2000-01-01", local_patient_id_3: "12345678" },
          found: true
        },
        {
          patient_args: { born_on: "2000-01-01", local_patient_id_4: "12345678" },
          locator_args: { born_on: "2000-01-01", local_patient_id_4: "12345678" },
          found: true
        },
        {
          patient_args: { born_on: "2000-01-01", local_patient_id_5: "12345678" },
          locator_args: { born_on: "2000-01-01", local_patient_id_5: "12345678" },
          found: true
        },
        {
          patient_args: { born_on: "2000-01-01", local_patient_id_5: "XXX" },
          locator_args: { born_on: "2000-01-01", local_patient_id_5: "12345678" },
          found: false
        }
      ].each do |hash|
        it hash.to_s do
          patient_args = hash[:patient_args]
          patient = create(
            :patient,
            nhs_number: patient_args[:nhs_number],
            born_on: patient_args[:born_on],
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

          if hash[:log_close_match] == true
            allow(Log).to receive(:create!)
          end

          result = described_class.call(patient_identification: patient_identification)

          if hash[:found]
            expect(result).to eq(patient)
          else
            expect(result).to be_nil
          end

          if hash[:log_close_match] == true
            expect(Log).to have_received(:create!)
          end
        end
      end

      # context "when more than one patient is found" do
      #   it "raises an error" do
      #     create(:patient,
      #       nhs_number: patient_args[:nhs_number],
      #       born_on: patient_args[:born_on],
      #       local_patient_id: patient_args[:local_patient_id] || Time.zone.now.to_i,
      #       local_patient_id_2: patient_args[:local_patient_id_2],
      #       local_patient_id_3: patient_args[:local_patient_id_3],
      #       local_patient_id_4: patient_args[:local_patient_id_4],
      #       local_patient_id_5: patient_args[:local_patient_id_5]
      #     )
      #   end
      # end
    end
  end
end
