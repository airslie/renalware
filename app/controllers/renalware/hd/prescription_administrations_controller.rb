require "collection_presenter"

module Renalware
  module HD
    class PrescriptionAdministrationsController < BaseController
      include Renalware::Concerns::PatientVisibility
      include Renalware::Concerns::PatientCasting
      include Pagy::Backend

      before_action :find_and_load_patient_from_prescription, except: [:index]

      def index
        pagy, administrations = pagy(
          hd_patient
            .prescription_administrations
            .includes(:administered_by, :witnessed_by, :reason, :prescription)
            .ordered
        )
        authorize administrations
        render locals: { prescription_administrations: administrations, pagy: pagy }
      end

      # GET HTML
      def new
        administration = hd_patient.prescription_administrations.build(
          prescription: prescription,
          administered_by: current_user,
          recorded_on: Date.current
        )
        render_new(administration)
      end

      # POST JS
      # issues - user validation not working
      def create
        administration = hd_patient.prescription_administrations.build(
          prescription_administration_parameters
        )
        clear_irrelevant_attributes_if_drug_was_not_administered(administration)
        authorize administration
        if administration.save_by(current_user)
          # will render create.js
        else
          render_new(administration) # re-display dialog with errors
        end
      end

      def destroy
        administration = HD::PrescriptionAdministration
          .where(prescription: prescription)
          .find(params[:id])

        authorize administration
        administration.destroy!
        redirect_to patient_hd_dashboard_path(prescription.patient)
      end

      private

      def clear_irrelevant_attributes_if_drug_was_not_administered(administration)
        unless administration.administered
          administration.administered_by = nil
          administration.witnessed_by = nil
        end
      end

      def prescription
        @prescription ||= Medications::Prescription.find_by(
          id: params[:prescription_id],
          administer_on_hd: true
        )
      end

      # Because for actions other than index we have no params[:patient_id] (secure_id guid) in
      # the url, here we set @patient (normally set in BaseController) based on the
      # prescription.patient_id. We need @patient set before calling hd_patient which is defined
      # dynamically in the PatientCasting concern (and will memoise on first call).
      def find_and_load_patient_from_prescription
        @patient ||= patient_scope.find(prescription&.patient_id)
      end

      def render_new(administration)
        authorize administration
        render :new, locals: { prescription_administration: administration }, layout: false
      end

      def prescription_administration_parameters
        params
          .require(:hd_prescription_administration)
          .permit(
            [
              :administered, :prescription_id, :notes, :reason_id,
              :administered_by_id,
              :witnessed_by_id, :administered_by_password, :witnessed_by_password,
              :skip_witness_validation, :recorded_on
            ]
          )
      end
    end
  end
end
