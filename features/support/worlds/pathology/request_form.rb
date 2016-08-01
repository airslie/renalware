module World
  module Pathology
    module RequestForm
      module Domain
        # @section helpers
        #
        def extract_request_form_params(form_params)
          clinic = find_requested_clinic(form_params[:clinic])
          consultant = find_or_create_requested_consultant(form_params[:consultant])
          patients = find_requested_patients(form_params[:patients])
          telephone = form_params[:telephone]

          params = {}
          if patients.present?
            params[:patients] = patients
            params[:patient_ids] = patients.map(&:id)
          end

          params[:clinic_id] = clinic.id if clinic.present?
          params[:consultant_id] = consultant.id if consultant.present?
          params[:telephone] = telephone if telephone.present?
          params[:by] = Renalware::SystemUser.find
          params
        end

        def build_request_forms(patients, options)
          request_params =
            Renalware::Pathology::Requests::RequestParamsFactory.new(options).build

          requests =
            Renalware::Pathology::Requests::RequestsFactory
            .new(patients, request_params).build

          Renalware::Pathology::Requests::RequestPresenter.present(requests)
        end

        # @section commands
        #
        def generate_request_forms_for_single_patient(_clinician, params)
          options = extract_request_form_params(params)

          build_request_forms(options[:patients], options)
        end

        def generate_request_forms_for_appointments(clinician, appointments, params)
          options = extract_request_form_params(params)

          options[:patients] = appointments.map do |appointment|
            Renalware::Pathology.cast_patient(appointment.patient)
          end

          build_request_forms(options[:patients], options)
        end

        def create_request(params)
          request_descriptions =
            params[:request_descriptions].map do |code|
              Renalware::Pathology::RequestDescription.find_or_create_by(code: code)
            end

          Renalware::Pathology::Requests::Request.create!(
            patient: Renalware::Pathology.cast_patient(params[:patient]),
            clinic: Renalware::Clinics::Clinic.first,
            consultant: Renalware::Pathology::Consultant.first,
            telephone: "123",
            by: Renalware::SystemUser.find,
            request_descriptions: request_descriptions,
            created_at: params[:requested_at],
            updated_at: params[:requested_at]
          )
        end

        # @section expectations
        #
        def expect_patient_summary_to_match_table(request_forms, patient, expected_table)
          request_form = find_request_form_for_patient(request_forms, patient)

          expected_table.rows_hash.each do |key, expected_value|
            expected_value = nil if expected_value.blank?

            expect(request_form.send(key.to_sym).to_s).to eq(expected_value.to_s)
          end
        end

        def expect_patient_specific_test(request_forms, patient, expected_test_description)
          request_form = find_request_form_for_patient(request_forms, patient)

          request_form.patient_requests_by_lab.each do |_lab_name, patient_rules|
            patient_rules.each do |patient_rule|
              expect(patient_rule.test_description).to eq(expected_test_description)
            end
          end
        end

        def expect_request_description_required(request_forms, patient, expected_request_description_code)
          request_form = find_request_form_for_patient(request_forms, patient)
          patient_request_descriptions = request_form.global_requests_by_lab.values.flatten

          expected_request_description =
            Renalware::Pathology::RequestDescription.find_by!(
              code: expected_request_description_code
            )

          expect(patient_request_descriptions).to include(expected_request_description)
        end

        def expect_no_request_descriptions_required(request_forms, patient)
          request_form = find_request_form_for_patient(request_forms, patient)
          required_request_descriptions = request_form.global_requests_by_lab.values.flatten

          expect(required_request_descriptions.count).to eq(0)
        end

        def expect_pathology_form(request_forms, patient, expected_pathology)
          request_description = expected_pathology[:global_pathology]
          patient_test = expected_pathology[:patient_pathology]

          if expected_pathology[:global_pathology].present?
            expect_request_description_required(request_forms, patient, request_description)
          else
            expect_no_request_descriptions_required(request_forms, patient)
          end

          expect_patient_specific_test(request_forms, patient, patient_test)
        end

        def expect_pathology_forms_for_patients(request_forms, patients)
          request_forms_names = request_forms.map { |request_form| request_form.patient.full_name }
          patient_names = patients.map(&:full_name)

          expect(request_forms_names).to eq(patient_names)
        end

        private

        def find_request_form_for_patient(request_forms, patient)
          request_forms.detect do |request_form|
            request_form.patient.id == patient.id
          end
        end

        def find_requested_clinic(clinic_name)
          return unless clinic_name.present?

          Renalware::Clinics::Clinic.find_by!(name: clinic_name)
        end

        def find_or_create_requested_consultant(consultant_names)
          return unless consultant_names.present?

          given_name, family_name = consultant_names.split(" ")
          consultant = Renalware::Pathology::Consultant.find_by(
            given_name: given_name,
            family_name: family_name
          )

          if consultant.present?
            consultant
          else
            create_user(given_name: given_name, family_name: family_name)
          end
        end

        def find_requested_patients(patients)
          return unless patients.present?

          if patients.first.is_a? String
            patients.split(", ").map do |patient_family_name|
              Renalware::Pathology::Patient.find_by!(family_name: patient_family_name)
            end
          else
            patients
          end
        end
      end

      module Web
        include Domain
        # @section commands
        #
        def generate_request_forms_for_single_patient(clinician, params)
          patients = find_requested_patients(params[:patients])
          clinic = find_requested_clinic(params[:clinic])
          consultant = find_or_create_requested_consultant(params[:consultant])
          telephone = params[:telephone]


          login_as clinician

          visit patient_pathology_required_observations_path(patient_id: patients.first.id)

          click_on "Generate Forms"

          update_request_form_clinic(clinic.name) if clinic.present?
          update_request_form_consultant(consultant.full_name) if consultant.present?
          update_request_form_telephone(telephone)  if telephone.present?
        end

        def generate_request_forms_for_appointments(_clinician, _appointments, params)
          clinic = find_requested_clinic(params[:clinic])

          click_on "Generate request forms"

          update_request_form_clinic(clinic.name)
        end

        # @section expectations
        #
        def expect_patient_summary_to_match_table(_request_forms, patient, expected_table)
          expected_table.rows_hash.each do |key, expected_value|
            xpath =
              "//div[data-patient-id='#{patient.id}'][data-role='form_summary']//td[data-role='#{key}']"
            value_in_web = find(xpath).text
            expect(value_in_web).to eq(expected_value)
          end
        end

        def expect_patient_specific_test(request_forms, patient, test_description)
          request_form = find_request_form_for_patient(request_forms, patient)

          expect(request_form).to include(test_description)
        end

        def expect_no_request_descriptions_required(request_forms, patient)
          request_form = find_request_form_for_patient(request_forms, patient)

          expect(request_form).to include("No tests required.")
        end

        def expect_request_description_required(request_forms, patient, request_description_code)
          request_form = find_request_form_for_patient(request_forms, patient)
          request_description =
            Renalware::Pathology::RequestDescription.find_by(code: request_description_code)

          expect(request_form.downcase).to include(request_description.name.downcase)
        end

        def expect_pathology_forms_for_patients(request_forms, patients)
          patients.each do |patient|
            request_form = find_request_form_for_patient(request_forms, patient)

            expect(request_form.present?).to be_truthy
          end
        end

        private

        def find_request_form_for_patient(_request_forms, patient)
          find("div[data-patient-id='#{patient.id}'][data-role='form_pathology']").text
        end

        def update_request_form_consultant(consultant_full_name)
          select consultant_full_name, from: "Consultant"
          click_on "Update Forms"
        end

        def update_request_form_clinic(clinic_name)
          select clinic_name, from: "Clinic"
          click_on "Update Forms"
        end

        def update_request_form_telephone(telephone)
          fill_in "Telephone", with: telephone
          click_on "Update Forms"
        end
      end
    end
  end
end
