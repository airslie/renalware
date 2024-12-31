module Renalware
  module API
    module V1
      module Medications
        class PrescriptionsController < TokenAuthenticatedAPIController
          def index
            render locals: {
              patient: patient,
              prescriptions: current_prescriptions_presenter
            }
          end

          private

          def current_prescriptions_presenter
            CollectionPresenter.new(
              current_prescriptions,
              Renalware::Medications::PrescriptionPresenter
            )
          end

          def current_prescriptions
            Renalware::Medications::PrescriptionsQuery.new(
              relation: patient.prescriptions.current
            ).call
          end

          def patient
            Patient.find_by!(secure_id: params[:patient_id])
          end
        end
      end
    end
  end
end
