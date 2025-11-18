module Renalware::Patients::Ingestion
  describe Commands::MergePatient do
    include HL7Helpers
    include PatientsSpecHelper

    subject(:service) { described_class }

    let(:system_user) { create(:user, username: Renalware::SystemUser.username) }
    let(:fallback_rule) {
      create(:patient_merge_rule, schema_name: "renalware", table_name: "*", merge: true)
    }

    before do
      allow(Renalware.config).to receive_messages(
        patient_hospital_identifiers: {
          HOSP_A: :local_patient_id,
          HOSP_B: :local_patient_id_2,
          HOSP_E: :local_patient_id_5,
          HOSP_C: :local_patient_id_3,
          HOSP_D: :local_patient_id_4
        }
      )
      allow(Renalware.config.hl7_patient_locator_strategy)
        .to receive(:fetch)
        .with(:adt)
        .and_return(:nhs_or_any_assigning_auth_number)

      system_user
    end

    describe "#call" do
      context "when to do" do
        it "to do" do
          fallback_rule
          major_patient = create(
            :patient,
            local_patient_id: "MAJ123",
            nhs_number: "9999999999",
            born_on: Date.new(2001, 1, 1)
          )

          minor_patient = create(
            :patient,
            local_patient_id: "MIN456",
            born_on: Date.new(2002, 2, 2)
          )

          msh = "MSH|^~\&|ADT||||20150122154918||ADT^A34|897847653|P|2.3"
          pid = "PID||" \
                "9999999999^^^NHS|" \
                "MAJ123^^^HOSP_A~" \
                "||#{major_patient.family_name}^#{major_patient.given_name}^^^MS||" \
                "20010101|#{major_patient.sex}|||"
          mrg = "MRG|MIN456^^^HOSP_A"

          hl7_message = Renalware::Feeds::HL7Message.new(::HL7::Message.new([msh, pid, mrg]))

          result = nil
          expect {
            result = described_class.call(hl7_message)
          }.to change(Renalware::Patient, :count).by(-1)
            .and not_change(Renalware::Patient.with_deleted, :count)

          expect(minor_patient.reload).to be_deleted
          expect(minor_patient).to have_attributes(
            merged_into_patient_id: major_patient.id,
            merged_at: be_within(2.seconds).of(Time.current)
          )
        end
      end
    end
  end
end
