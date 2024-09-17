# frozen_string_literal: true

module Renalware
  describe MDMHelper do
    def patient_with_modality(modality_trait: :pd)
      patient = Patient.new(id: 1)
      description = build(:modality_description, modality_trait)
      modality = Modalities::Modality.new(description: description)
      allow(patient).to receive(:current_modality).and_return(modality)
      patient
    end

    describe "#mdm_path_for resolves the correct MDM path for the patient's current modality" do
      context "when current modality is" do
        it "PD" do
          patient = patient_with_modality(modality_trait: :pd)
          link = link_to_mdm(patient)
          expect(link).to match(patient_pd_mdm_path(patient_id: patient))
        end

        it "HD" do
          patient = patient_with_modality(modality_trait: :hd)
          link = link_to_mdm(patient)
          expect(link).to match(patient_hd_mdm_path(patient_id: patient))
        end

        it "Transplant" do
          patient = patient_with_modality(modality_trait: :transplant)
          link = link_to_mdm(patient)
          expect(link).to match(patient_transplants_mdm_path(patient_id: patient))
        end

        it "Advanced Kidney Care" do
          patient = patient_with_modality(modality_trait: :low_clearance)
          link = link_to_mdm(patient)
          expect(link).to match(patient_low_clearance_mdm_path(patient_id: patient))
        end

        it "anything else resolves to nil" do
          patient = patient_with_modality(modality_trait: :death)
          link = link_to_mdm(patient)
          expect(link).to be_nil
        end
      end
    end
  end
end
