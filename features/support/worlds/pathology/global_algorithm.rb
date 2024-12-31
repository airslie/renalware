module World
  module Pathology
    module GlobalAlgorithm
      module Domain
        # @section commands

        def create_global_rule(params)
          param_id =
            case params["type"]
            when "ObservationResult"
              Renalware::Pathology::ObservationDescription.find_by!(code: params["id"]).id
            when "RequestResult"
              Renalware::Pathology::RequestDescription.find_by!(code: params["id"]).id
            when "PrescriptionDrug"
              Renalware::Drugs::Drug.find_by!(name: params["id"]).id
            when "PrescriptionDrugType"
              Renalware::Drugs::Type.find_by!(name: params["id"]).id
            when "PrescriptionDrugCategory"
              Renalware::Pathology::Requests::DrugCategory.find_by(name: params["id"]).id
            end

          rule_set =
            if params["rule_set_type"] == "Renalware::Pathology::Requests::HighRiskRuleSet"
              Renalware::Pathology::Requests::HighRiskRuleSet.new
            else
              Renalware::Pathology::Requests::GlobalRuleSet.new(id: params["rule_set_id"])
            end

          Renalware::Pathology::Requests::GlobalRule.create!(
            rule_set: rule_set,
            type: "Renalware::Pathology::Requests::GlobalRule::#{params['type']}",
            param_id: param_id,
            param_comparison_operator: params["operator"],
            param_comparison_value: params["value"]
          )
        end

        def create_global_rules_from_table(table)
          table.rows.map do |row|
            params = table.headers.zip(row).to_h
            params["rule_set_id"] = @rule_set.id
            params["operator"] = nil if params["operator"].blank?
            params["value"] = nil if params["value"].blank?
            create_global_rule(params)
          end
        end

        def create_global_rule_set(params)
          request_description =
            Renalware::Pathology::RequestDescription.find_by!(
              code: params["request_description_code"]
            )

          params["request_description_id"] = request_description.id

          clinic =
            Renalware::Clinics::Clinic.find_by!(
              name: params["clinic"]
            )
          params["clinic"] = clinic

          Renalware::Pathology::Requests::GlobalRuleSet.create!(
            params.except("request_description_code")
          )
        end

        def run_global_algorithm(patient, _clinician, clinic_name)
          pathology_patient = Renalware::Pathology.cast_patient(patient)
          clinic = Renalware::Clinics::Clinic.find_by(name: clinic_name)

          Renalware::Pathology::Requests::GlobalAlgorithm
            .new(pathology_patient, clinic)
            .determine_required_request_descriptions
        end

        # @section expectations
        #
        def expect_observations_from_global(required_global_observations,
                                            observations_table)
          observations_table.rows.each do |row|
            request_description = Renalware::Pathology::RequestDescription.find_by!(code: row.first)
            expect(required_global_observations).to include(request_description)
          end
        end
      end

      module Web
        include Domain

        def run_global_algorithm(patient, clinician, clinic_name)
          login_as clinician

          clinic = Renalware::Clinics::Clinic.find_by(name: clinic_name)

          visit patient_pathology_required_observations_path(
            patient_id: patient,
            request: { clinic_id: clinic.id }
          )

          html_table_to_array("global_pathology")
        end

        def expect_observations_from_global(required_global_observations, observations_table)
          expect(required_global_observations).to eq(observations_table.raw)
        end
      end
    end
  end
end
