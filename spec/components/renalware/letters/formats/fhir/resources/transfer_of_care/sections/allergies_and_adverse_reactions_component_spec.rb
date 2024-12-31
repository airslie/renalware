module Renalware::Letters::Formats::FHIR
  module Resources::TransferOfCare
    describe Sections::AllergiesAndAdverseReactionsComponent, type: :component do
      context "when the patient has allergies" do
        it do
          patient = build_stubbed(:patient)
          clinical_patient = Renalware::Clinical.cast_patient(patient)
          allergies = [
            build_stubbed(:allergy, patient: clinical_patient, description: "Allergy 1"),
            build_stubbed(:allergy, patient: clinical_patient, description: "Allergy 2")
          ]
          allow(clinical_patient).to receive(:allergies).and_return(allergies)
          letter = instance_double(Renalware::Letters::Letter, patient: patient)
          allow(Renalware::Clinical).to receive(:cast_patient).and_return(clinical_patient)

          render_inline(described_class.new(letter))

          expect(page).to have_content("Allergy 1")
          expect(page).to have_content("Allergy 2")
        end
      end

      context "when the patient has no recorded allergies" do
        it do
          patient = build_stubbed(:patient)
          letter = instance_double(Renalware::Letters::Letter, patient: patient)

          render_inline(described_class.new(letter))

          expect(page).to have_content("No recorded allergies")
        end
      end

      context "when the patient has an allergy status of 'no_known_allergies'" do
        it do
          user = create(:user)
          patient = create(:patient, by: user)
          clinical_patient = Renalware::Clinical.cast_patient(patient)
          clinical_patient.update!(allergy_status: "no_known_allergies", by: user)
          letter = instance_double(Renalware::Letters::Letter, patient: patient)

          render_inline(described_class.new(letter))

          expect(page).to have_content("No known allergy")
        end
      end
    end
  end
end
