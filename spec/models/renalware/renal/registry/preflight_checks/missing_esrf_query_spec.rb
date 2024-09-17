# frozen_string_literal: true

module Renalware
  module Renal
    module Registry
      describe PreflightChecks::MissingESRFQuery do
        let(:user) { create(:user) }
        let(:hd) { create(:hd_modality_description) }
        let(:pd) { create(:pd_modality_description) }
        let(:transplant) { create(:transplant_modality_description) }

        def change_patient_modality(patient, modality_description, user)
          create(:modality_change_type, :default)
          result = Modalities::ChangePatientModality
            .new(patient: patient, user: user)
            .call(description: modality_description, started_on: Time.zone.now)
          expect(result).to be_success
        end

        def assign_ersf_on_date_to(patient, esrf_on)
          Renal.cast_patient(patient).create_profile(esrf_on: esrf_on)
          patient
        end

        def create_patient_with_modality(modality_description)
          patient = create(:patient, by: user)
          if modality_description
            change_patient_modality(patient, modality_description, user)
            expect(patient.reload.current_modality.description).to eq(modality_description)
          end
          Renalware::Renal.cast_patient(patient)
        end

        def create_patient(modality, esrf_on:)
          create_patient_with_modality(modality).tap do |pat|
            assign_ersf_on_date_to(pat, esrf_on)
          end
        end

        describe "#call" do
          it "only returns patients with having no esrf_on date" do
            create_patient(hd, esrf_on: "2012-01-01") # hd_patient_with_esrf
            hd_patient_without_esrf = create_patient(hd, esrf_on: nil)

            patients = described_class.new.call

            expect(patients.to_a).to eq([hd_patient_without_esrf])
          end

          it "only returns HD PD and Transplant patients" do
            hd_patient = create_patient(hd, esrf_on: nil)
            pd_patient = create_patient(pd, esrf_on: nil)
            tx_patient = create_patient(transplant, esrf_on: nil)
            create_patient(nil, esrf_on: nil) # patient_with_no_modality

            patients = described_class.new.call

            expect(patients.to_a.sort).to contain_exactly(hd_patient, pd_patient, tx_patient)
          end
        end
      end
    end
  end
end
