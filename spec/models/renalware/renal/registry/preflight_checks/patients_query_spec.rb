# frozen_string_literal: true

module Renalware
  module Renal
    module Registry
      describe PreflightChecks::PatientsQuery do
        let(:user) { create(:user) }

        def change_patient_modality(patient, modality_description, user)
          create(:modality_change_type, :default)
          result = Modalities::ChangePatientModality
            .new(patient: patient, user: user)
            .call(description: modality_description, started_on: Time.zone.now)
          expect(result).to be_success
        end

        def create_hd_patient
          create_patient_with_modality(create(:hd_modality_description))
        end

        def create_pd_patient
          create_patient_with_modality(create(:pd_modality_description))
        end

        def create_tx_patient
          create_patient_with_modality(create(:transplant_modality_description))
        end

        def create_death_patient
          create_patient_with_modality(create(:death_modality_description))
        end

        def create_patient_with_modality(modality_description)
          patient = create(:patient, by: user)
          change_patient_modality(patient, modality_description, user)
          expect(patient.reload.current_modality.description).to eq(modality_description)
          create(:renal_profile, patient: Renal.cast_patient(patient), esrf_on: 1.month.ago)
          Renalware::Renal.cast_patient(patient)
        end

        def create_patient_passing_preflight_checks
          create_hd_patient.tap do |patient|
            patient.update!(ethnicity: create(:ethnicity, :white_british), by: user)
            Renal.cast_patient(patient).profile.update!(esrf_on: 1.month.ago)
            patient.reload
          end
        end

        describe "#call" do
          it "returns only patients with certain modalities" do
            hd_patient = create_hd_patient
            pd_patient = create_pd_patient
            tx_patient = create_tx_patient
            death_patient = create_death_patient

            patients = described_class.new.call

            expect(patients.count).to eq(3)
            expect(patients).to include(pd_patient)
            expect(patients).to include(hd_patient)
            expect(patients).to include(tx_patient)
            expect(patients).not_to include(death_patient)
          end

          it "returns patients without an ethnicity" do
            create_patient_passing_preflight_checks
            patient_with_no_ethnicity = create_patient_passing_preflight_checks
            patient_with_no_ethnicity.update(ethnicity_id: nil)

            patients = described_class.new.call

            expect(patients.count).to eq(1)
            expect(patients).to eq([patient_with_no_ethnicity])
          end

          it "returns patients with no primary renal diagnosis (PRD) on their renal profile" do
            create_patient_passing_preflight_checks
            patient_with_no_prd = create_patient_passing_preflight_checks
            Renal.cast_patient(patient_with_no_prd).profile.update(prd_description_id: nil)

            patients = described_class.new.call

            expect(patients).to eq([patient_with_no_prd])
          end

          it "returns patients with no first_seen_on date in their renal profile" do
            create_patient_passing_preflight_checks
            patient_with_no_first_seen_date = create_patient_passing_preflight_checks
            Renal.cast_patient(patient_with_no_first_seen_date).profile.update(first_seen_on: nil)

            patients = described_class.new.call

            expect(patients).to eq([patient_with_no_first_seen_date])
          end

          it "returns patients with no comorbidities set their renal profile" do
            # We actually only test that the ischaemic_heart_dis comorb is set and assume if it
            # isn't then none of the others will be as they are usually set at the same time.
            # This suits us because checking every comorb is more verbose and complex.
            create_patient_passing_preflight_checks
            patient_with_no_comoorbs = create_patient_passing_preflight_checks
            renal_patient = Renal.cast_patient(patient_with_no_comoorbs)
            renal_patient.profile.document.comorbidities.ischaemic_heart_dis.status = nil
            renal_patient.profile.save!

            patients = described_class.new.call

            expect(patients).to eq([patient_with_no_comoorbs])
          end
        end
      end
    end
  end
end
