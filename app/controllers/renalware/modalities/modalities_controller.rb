# frozen_string_literal: true

module Renalware
  module Modalities
    class ModalitiesController < BaseController
      include Renalware::Concerns::PatientVisibility

      def new
        modality = Modality.new(patient: patient)
        authorize modality
        render locals: { patient: patient, modality: modality }
      end

      def index
        authorize Modality, :index?
        modalities = patient
                       .modalities
                       .includes([:description, :created_by])
                       .ordered
        render locals: { patient: patient, modalities: modalities }
      end

      def create
        authorize Modality, :create?
        result = change_patient_modality
        if result.success?
          handle_valid_modality
        else
          flash.now[:error] = failed_msg_for("modality")
          render :new, locals: { patient: patient, modality: result.object }
        end
      end

      private

      def change_patient_modality
        Modalities::ChangePatientModality
          .new(patient: patient, user: current_user)
          .broadcasting_to_configured_subscribers
          .call(modality_params)
      end

      def params_are_valid?
        Modality.new(modality_params).valid?
      end

      def modality_params
        params.require(:modality)
              .permit(:description_id, :modal_change_type, :reason_id, :notes, :started_on)
      end

      # TODO: refactor
      # rubocop:disable Metrics/MethodLength
      def handle_valid_modality
        description = patient.modality_description
        if description.is_a? Deaths::ModalityDescription
          redirect_to edit_patient_death_path(patient), flash: {
            warning: "Please make sure to update patient date of death and cause of death!"
          }
        elsif description.is_a? Transplants::DonorModalityDescription
          redirect_to new_patient_transplants_donation_path(patient), flash: {
            warning: "If you have the information on-hand, please enter the potential donation."
          }
        else
          redirect_to patient_modalities_path(patient),
                      notice: success_msg_for("modality")
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
