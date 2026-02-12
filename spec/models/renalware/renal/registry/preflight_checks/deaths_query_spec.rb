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
          assign_esrf_on_date_to(patient, nil)
        end

        def create_death_patient(esrf_on: nil, died_on: nil, first_cause: nil)
          esrf_on ||= Time.zone.today
          died_on ||= 1.year.ago.to_date
          patient = create_patient_with_modality(create(:death_modality_description))
          patient.update_column(:died_on, died_on)
          patient.update_column(:first_cause_id, first_cause) if first_cause
          assign_esrf_on_date_to(patient, esrf_on)
        end

        def assign_esrf_on_date_to(patient, esrf_on)
          Renal.cast_patient(patient).create_profile(esrf_on: esrf_on)
          patient
        end

        def create_patient_with_modality(modality_description)
          patient = create(:patient, :minimal, by: user)
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

          context "when filtering" do
            it "finds only patients with esrf_on date after specified date" do
              # Create a patient with an esrf_on date before the filter date
              _patient_w_early_esrf = create_death_patient(esrf_on: 1.year.ago, first_cause: nil)

              # Create a patient with an esrf_on date after the filter date
              patient_w_late_esrf = create_death_patient(esrf_on: 1.year.from_now, first_cause: nil)

              query_params = { profile_esrf_on_gteq: Time.zone.today.to_s }
              patients = described_class.new(query_params: query_params).call

              expect(patients).to eq([patient_w_late_esrf])
            end
          end

          context "when sorting" do
            it "sorts by esrf_on date" do
              patient_w_early_esrf = create_death_patient(esrf_on: 1.year.ago, first_cause: nil)
              patient_w_late_esrf = create_death_patient(esrf_on: 1.year.from_now, first_cause: nil)

              query_params = { s: "profile_esrf_on asc" }
              patients = described_class.new(query_params: query_params).call

              expect(patients).to eq([patient_w_early_esrf, patient_w_late_esrf])

              query_params = { s: "profile_esrf_on desc" }
              patients = described_class.new(query_params: query_params).call

              expect(patients).to eq([patient_w_late_esrf, patient_w_early_esrf])
            end

            it "sorts by died_on date" do
              patient_w_early_died = create_death_patient(died_on: 1.year.ago, first_cause: nil)
              patient_w_late_died = create_death_patient(died_on: 1.year.from_now, first_cause: nil)

              query_params = { s: "died_on asc" }
              patients = described_class.new(query_params: query_params).call

              expect(patients).to eq([patient_w_early_died, patient_w_late_died])

              query_params = { s: "died_on desc" }
              patients = described_class.new(query_params: query_params).call

              expect(patients).to eq([patient_w_late_died, patient_w_early_died])
            end
          end
        end
      end
    end
  end
end
