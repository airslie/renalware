module Renalware
  module Patients
    module Ingestion
      describe MessageMappers::Patient do
        include HL7Helpers
        subject { described_class.new(message) }

        before do
          allow(Renalware.config).to receive_messages(
            patient_hospital_identifiers: {
              HOSP1: :local_patient_id
            }
          )
          allow(Renalware.config.hl7_patient_locator_strategy)
            .to receive(:fetch)
            .with(:adt)
            .and_return(:simple)
        end

        def hl7_data
          OpenStruct.new(
            hospital_number: "A123",
            nhs_number: "0000000001",
            family_name: "new_family_name",
            given_name: "new_given_name",
            born_on: Time.zone.parse("2002-02-01").to_date,
            died_at: Time.zone.parse("2003-03-02").to_date,
            gp_code: "G123",
            practice_code: "P456",
            sex: "M"
          )
        end

        let(:primary_care_physician) { build_stubbed(:primary_care_physician) }
        let(:practice) { build_stubbed(:practice) }

        it "maps a message to a patient" do
          message = hl7_message_from_file("ADT_A31", hl7_data)
          mapped_patient = described_class.new(message)

          stub_primary_care_physician_find
          stub_practice_find

          actual = mapped_patient.fetch

          expect(actual).to have_attributes(
            local_patient_id: message.patient_identification.internal_id,
            nhs_number: message.patient_identification.nhs_number,
            given_name: message.patient_identification.given_name,
            family_name: message.patient_identification.family_name,
            title: message.patient_identification.title,
            born_on: Time.zone.parse(message.patient_identification.born_on).to_date,
            died_on: Time.zone.parse(message.patient_identification.died_at).to_date,
            primary_care_physician: primary_care_physician,
            practice: practice
          )
          expect(actual.sex.code).to eq(message.patient_identification.sex)

          expect(actual.current_address).to have_attributes(
            street_1: "address1",
            street_2: "address2",
            town: "address3",
            county: "address4",
            postcode: "postcode"
          )
        end

        def stub_primary_care_physician_find
          allow(
            Renalware::Patients::PrimaryCarePhysician
          ).to receive(:find_by).and_return(primary_care_physician)
        end

        def stub_practice_find
          allow(
            Renalware::Patients::Practice
          ).to receive(:find_by).and_return(practice)
        end

        # it "updates the primary_care_physician on the Renalware patient" do
        #   data = hl7_data
        #   primary_care_physician = create(:primary_care_physician, code: data.gp_code)
        #   rw_patient = create(
        #     :patient,
        #     local_patient_id: data.hospital_number,
        #     primary_care_physician: nil
        #   )
        #   hl7_message = hl7_message_from_file("ADT_A31", data)

        #   service.call(hl7_message)

        #   expect(rw_patient.reload.primary_care_physician).to eq(primary_care_physician)
        # end

        # it "updates the practice on the Renalware patient" do
        #   data = hl7_data
        #   practice = create(:practice, code: data.practice_code)
        #   rw_patient = create(
        #     :patient,
        #     local_patient_id: data.hospital_number,
        #     practice: nil
        #   )
        #   hl7_message = hl7_message_from_file("ADT_A31", data)

        #   service.call(hl7_message)

        #   expect(rw_patient.reload.practice).to eq(practice)
        # end
      end
    end
  end
end
