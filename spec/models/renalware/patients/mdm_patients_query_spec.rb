module Renalware
  describe Patients::MDMPatientsQuery do
    include PatientsSpecHelper
    subject(:query) { described_class }

    let(:user) { create(:user) }
    let(:hd_modality_description) { create(:hd_modality_description) }
    let(:pd_modality_description) { create(:modality_description, name: "PD") }

    describe "#call" do
      it "returns only patients with a current HD modality" do
        hd_patient = create(:patient)
        set_modality(patient: hd_patient,
                     modality_description: hd_modality_description)

        pd_patient = create(:patient) # was hd, now pd, so so should not be selected
        set_modality(patient: pd_patient,
                     modality_description: hd_modality_description,
                     started_on: Time.zone.today - 1)
        set_modality(patient: pd_patient,
                     modality_description: pd_modality_description,
                     started_on: Time.zone.today)

        patients = described_class.new(modality_names: "HD", q: nil).call

        expect(patients.count).to eq(1)
        expect(patients.first.id).to be(hd_patient.id)
      end
    end
  end
end
