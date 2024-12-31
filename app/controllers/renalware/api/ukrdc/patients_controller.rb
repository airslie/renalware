module Renalware
  module API
    module UKRDC
      class PatientsController < BaseController
        respond_to :xml

        def show
          respond_to do |format|
            format.xml { render xml: patient_ukrdc_xml }
          end
        end

        private

        def patient_ukrdc_xml
          result = attempt_to_generate_patient_ukrdc_xml
          if result.failure?
            result.validation_errors.to_xml
          else
            result.xml
          end
        end

        def attempt_to_generate_patient_ukrdc_xml
          Renalware::UKRDC::XmlRenderer.new(
            schema: Renalware::UKRDC::XsdSchema.new,
            locals: { patient: patient_presenter }
          ).call
        end

        def patient_presenter
          patient = Renalware::Patient.find_by!(secure_id: params[:id])
          authorize patient
          changes_since = params.fetch(:changes_since, "2018-01-01")
          Renalware::UKRDC::PatientPresenter.new(patient, changes_since: changes_since)
        end
      end
    end
  end
end
