module Renalware
  module Medications
    class PrescriptionBatchRenewalsController < BaseController
      include PresenterHelper
      include ActionView::Helpers::TextHelper

      class FormObject
        include ActiveModel::Model
        include ActiveModel::Attributes

        attribute :prescriptions, array: true

        def prescription_ids
          prescriptions.map(&:id)
        end
      end

      def new
        authorize :"renalware/medications/prescription_batch_renewal", :new?
        render locals: {
          patient: patient,
          form: FormObject.new(prescriptions: prescriptions)
        }
      end

      def create
        authorize :"renalware/medications/prescription_batch_renewal", :create?
        posted_prescriptions.each { |prescription| renew(prescription) }
        notice = "#{pluralize(posted_prescriptions.length, 'prescription')} renewed"
        redirect_to patient_prescriptions_path(patient), notice: notice
      end

      private

      def posted_prescriptions
        patient.prescriptions.find(posted_prescription_ids)
      end

      def posted_prescription_ids
        prescription_batch_params
          .fetch(:prescription_ids, [])
          .map(&:to_i)
          .reject(&:zero?)
      end

      def renew(prescription)
        RenewPrescription.call(
          prescription: prescription,
          auto_terminate_after: Renalware.config.auto_terminate_hd_prescriptions_after_period,
          by: current_user
        )
      end

      def prescriptions
        present(RenewableHDPrescriptionsQuery.call(patient: patient), PrescriptionPresenter)
      end

      def prescription_batch_params
        params.require(:prescription_batch).permit(prescription_ids: [])
      end
    end
  end
end
