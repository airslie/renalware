module Renalware
  module Renal
    module Registry
      describe PreflightChecks::DeathsQuery do
        let(:user) { create(:user) }

        def change_patient_modality(patient, modality_description, user)
          create(:modality_change_type, :default)
          result = Modalities::ChangePatientModality
            .new(patient: patient, user: user)
            .call(description: modality_description, started_on: Time.zone.now)
          expect(result).to be_success
        end

        def create_hd_patient
          patient = create_patient_with_modality(create(:hd_modality_description))
          assign_ersf_on_date_to(patient, nil)
        end

        def create_death_patient
          patient = create_patient_with_modality(create(:death_modality_description))
          assign_ersf_on_date_to(patient, Time.zone.today)
        end

        def assign_ersf_on_date_to(patient, esrf_on)
          Renal.cast_patient(patient).create_profile(esrf_on: esrf_on)
          patient
        end

        def create_patient_with_modality(modality_description)
          patient = create(:patient, by: user)
          change_patient_modality(patient, modality_description, user)
          expect(patient.reload.current_modality.description).to eq(modality_description)
          Renalware::Renal.cast_patient(patient)
        end

        def create_patient_passing_preflight_checks
          create_death_patient.tap do |patient|
            patient.update!(
              first_cause: create(:cause_of_death),
              died_on: 1.week.ago.to_date,
              by: user
            )
          end
        end

        describe "#call" do
          it "only returns patients with a modality of death and having an esrf_on date" do
            create_hd_patient
            death_patient = create_death_patient

            patients = described_class.new.call

            expect(patients).to eq([death_patient])
          end

          it "returns only patients without first cause of death" do
            create_patient_passing_preflight_checks
            patient_with_no_cod = create_patient_passing_preflight_checks
            # Using update_column here (bypassing modal validation) as we can't set :first_cause
            # to nil using an update without getting a validation error
            patient_with_no_cod.update_column(:first_cause_id, nil)

            patients = described_class.new.call

            expect(patients).to eq([patient_with_no_cod])
          end
        end
      end
    end
  end
end
