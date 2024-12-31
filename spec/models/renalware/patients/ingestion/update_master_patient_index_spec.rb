module Renalware::Patients
  describe Ingestion::UpdateMasterPatientIndex do
    include HL7Helpers
    subject(:service) { described_class }

    before { create(:user, username: Renalware::SystemUser.username) }

    def hl7_data
      OpenStruct.new(
        hospital_number: "A123",
        nhs_number: "9999999999",
        family_name: "new_family_name",
        given_name: "new_given_name",
        born_on: Time.zone.parse("2002-02-01").to_date,
        died_at: Time.zone.parse("2003-03-02").to_date,
        gp_code: "G123",
        practice_code: "P456"
      )
    end

    describe "#call" do
      context "when an ORU pathology message" do
        it "does not update the master patient index" do
          hl7_message = hl7_message_from_file("ORU_R01", hl7_data)
          expect(hl7_message).to be_oru

          expect {
            service.call(hl7_message)
          }.not_to change(Abridgement, :count)
        end
      end

      %w(A01 A28 A31 A08 A02 A03 A11 A13).each do |adt_message_type|
        context "when an ADT {adt_message_type} message" do
          let(:filename) { "ADT_#{adt_message_type}" }

          context "when the patient does not exist in Renalware" do
            context "when the patient does not exist in the master patient index" do
              it "adds the patient to the master patient index" do
                hl7_message = hl7_message_from_file(filename, hl7_data)
                expect(hl7_message).to be_adt

                expect {
                  service.call(hl7_message)
                }.to change(Abridgement, :count).by(1)

                expect(Abridgement.first).to have_attributes(hl7_data.to_h)
              end
            end

            context "when the patient already exist in the master patient index" do
              it "updates the patient in the master patient index" do
                abridged_patient = create(
                  :abridged_patient,
                  hospital_number: "A123",
                  born_on: "1900-01-01"
                )
                hl7_message = hl7_message_from_file(filename, hl7_data)
                expect(hl7_message).to be_adt

                expect { service.call(hl7_message) }.not_to change(Abridgement, :count)

                expect(abridged_patient.reload).to have_attributes(hl7_data.to_h)
              end
            end

            context "when the patient exists in Renalware" do
              context "when the patient does not exist in the master patient index" do
                it "adds the patient to the master patient index and updates the patient_id " \
                   "to point to the renalware patient" do
                  rw_patient = create(:patient, local_patient_id: "A123")

                  hl7_message = hl7_message_from_file(filename, hl7_data)
                  expect(hl7_message).to be_adt

                  expect { service.call(hl7_message) }.to change(Abridgement, :count).by(1)

                  abridgement = Abridgement.find_by!(hospital_number: "A123")
                  expect(abridgement.patient_id).to eq(rw_patient.id)
                end
              end
            end
          end
        end
      end
    end
  end
end
