# frozen_string_literal: true

module Renalware
  module Transplants
    class RegistrationsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def show
        if registration.new_record?
          redirect_to edit_patient_transplants_registration_path(transplants_patient)
        else
          render locals: { patient: transplants_patient, registration: registration }
        end
      end

      def edit
        render locals: { patient: transplants_patient, registration: registration }
      end

      def update
        if update_registration
          redirect_to patient_transplants_recipient_dashboard_path(transplants_patient),
                      notice: success_msg_for("registration")
        else
          flash.now[:error] = failed_msg_for("registration")
          render :edit, locals: { patient: transplants_patient, registration: registration }
        end
      end

      protected

      def update_registration
        registration.attributes = registration_params
        registration.statuses.first.by = current_user if registration.new_record?
        registration.save
      end

      def registration
        @registration ||= Registration
          .for_patient(transplants_patient)
          .first_or_initialize
          .tap { |reg| authorize reg }
      end

      def registration_params
        params
          .require(:transplants_registration)
          .permit(attributes)
          .merge(document: document_attributes)
      end

      def attributes
        [
          :referred_on, :assessed_on, :entered_on, :contact, :notes,
          statuses_attributes: [:started_on, :description_id],
          document: []
        ]
      end

      def document_attributes
        params
          .require(:transplants_registration)
          .fetch(:document, nil).try(:permit!)
      end
    end
  end
end
