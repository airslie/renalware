module World
  module Pathology
    module PatientAlgorithm
      module Domain
        # @section commands
        #
        def create_patient_rule(patient, params)
          rule_params = params
            .symbolize_keys
            .except(:last_observed_at, :patient, :lab)
            .merge(lab: Renalware::Pathology::Lab.find_by!(name: params[:lab]))

          pathology_patient = Renalware::Pathology.cast_patient(patient)
          pathology_patient.rules.create(rule_params)
        end

        def record_patient_rule(patient, _clinician, params)
          create_patient_rule(patient, params)
        end

        def update_patient_rule_start_end_dates(patient_rule, within_rage)
          params =
            if within_rage == "yes"
              {
                start_date: Date.current - 1.day,
                end_date: Date.current + 1.day
              }
            else
              {
                start_date: Date.current - 2.days,
                end_date: Date.current - 1.day
              }
            end

          patient_rule.update!(params)
        end

        def run_patient_algorithm(patient, _clinician)
          pathology_patient = Renalware::Pathology.cast_patient(patient)

          Renalware::Pathology::Requests::PatientAlgorithm.new(pathology_patient)
            .determine_required_tests
        end

        # @section expectations
        #
        def expect_observations_from_patient(required_patient_observations, observations_table)
          observations_table.rows.each do |row|
            expect(required_patient_observations.map(&:test_description)).to include(row[1])
          end
        end

        def expect_patient_rules_on_patient(patient, patient_rule_attributes)
          pathology_patient = Renalware::Pathology.cast_patient(patient)
          expect(pathology_patient.rules.count).to eq(1)

          rule = pathology_patient.rules.first
          expect(rule).to have_attributes(patient_rule_attributes.except(:lab))
          expect(rule.lab.name).to eq(patient_rule_attributes[:lab])
        end

        def expect_patient_rule_to_be_refused(patient)
          pathology_patient = Renalware::Pathology.cast_patient(patient)
          expect(pathology_patient.rules.count).to eq(0)
        end
      end

      module Web
        include Domain

        def record_patient_rule(patient, clinician, params)
          login_as clinician

          visit new_patient_pathology_patient_rule_path(patient_id: patient)

          within "#new_pathology_requests_patient_rule" do
            select params[:lab], from: "Lab"
            fill_in "Test description", with: params[:test_description]
            select params[:sample_number_bottles].to_s, from: "Sample number bottles"
            select params[:frequency_type], from: "Frequency"
            fill_in "Start date", with: l(params[:start_date])
            fill_in "End date", with: l(params[:end_date])
            submit_form
          end
        end

        def run_patient_algorithm(patient, clinician)
          login_as clinician

          visit patient_pathology_required_observations_path(
            patient_id: patient
          )

          html_table_to_array("patient_pathology")
        end

        def expect_observations_from_patient(algorithm, observations_table)
          algorithm.map! do |row|
            row[0..-3] # NOTE: Remove the last two columns (Edit/Delete)
          end

          expect(algorithm).to eq(observations_table.raw)
        end
      end
    end
  end
end
