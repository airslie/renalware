describe Renalware::Clinical::Allergy do
  it_behaves_like "a Paranoid model"
  it_behaves_like "an Accountable model"
  it :aggregate_failures do
    is_expected.to validate_presence_of :description
    is_expected.to validate_presence_of :recorded_at
    is_expected.to belong_to(:patient).touch(true)
  end

  describe "allergy management workflows" do
    let(:clinician) { create(:user, :clinical) }
    let(:patient) { create(:patient) }
    let(:clinical_patient) { Renalware::Clinical.cast_patient(patient) }

    describe "adding allergies" do
      it "allows adding multiple allergies to a patient" do
        allergies_data = [
          { description: "Nuts" },
          { description: "Penicillin" }
        ]

        allergies_data.each do |allergy_data|
          clinical_patient.allergies.create!(
            description: allergy_data[:description],
            recorded_at: Time.zone.now,
            by: clinician
          )
        end

        expect(clinical_patient.allergies.pluck(:description)).to contain_exactly("Nuts",
                                                                                  "Penicillin")
      end
    end

    describe "removing allergies" do
      let!(:nuts_allergy) do
        clinical_patient.allergies.create!(
          description: "Nuts",
          recorded_at: Time.zone.now,
          by: clinician
        )
      end
      let!(:penicillin_allergy) do
        clinical_patient.allergies.create!(
          description: "Penicillin",
          recorded_at: Time.zone.now,
          by: clinician
        )
      end

      it "removes allergies and archives them" do
        expect {
          nuts_allergy.destroy
        }.to change { clinical_patient.allergies.count }.by(-1)

        expect {
          penicillin_allergy.destroy
        }.to change { clinical_patient.allergies.count }.by(-1)

        expect(clinical_patient.allergies.pluck(:description)).to be_empty
        expect(clinical_patient.allergies.only_deleted.pluck(:description)).to contain_exactly(
          "Penicillin", "Nuts"
        )
      end
    end

    describe "marking patient as having no known allergies" do
      it "updates patient allergy status" do
        status = :no_known_allergies
        patient.update_by(clinician, allergy_status: status)

        expect(patient.reload.allergy_status).to eq(status.to_s)
      end
    end
  end
end
