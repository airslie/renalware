module Renalware
  module Modalities
    class ModalitiesController < BaseController
      include Renalware::Concerns::PatientVisibility
      include ActionView::Helpers::TextHelper

      def index
        authorize Modality, :index?

        render locals: {
          patient: patient,
          modalities: modalities_with_noncontiguous_warnings_inserted
        }
      end

      def new
        modality = Modality.new(patient: patient)

        # If the change_type dropdown on this page changes, we refresh the turboframe
        # and this causes us to re-enter here with eg ..?change_type_id=3 on the url - in which case
        # assign the specified ChangeType so when we render the turboframe fields
        # (which depend on change_type) they can hide/show themselves appropriately.
        # See also modalities/new and select_controller.js
        if params[:change_type_id].present?
          modality.change_type = ChangeType.find(params[:change_type_id])
        end

        authorize modality
        render locals: { patient: patient, modality: modality }
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

      def destroy
        modality_to_delete = patient.modalities.find(params[:id])
        authorize modality_to_delete

        deleting_the_current_modality = patient.current_modality&.id == params[:id].to_i
        if deleting_the_current_modality
          delete_current_modality_and_make_previous_one_current(modality_to_delete)
        else
          modality_to_delete.destroy!
        end

        redirect_to patient_modalities_path(patient)
      end

      def edit
        modality = patient.modalities.find(params[:id])
        authorize modality
        render locals: { patient: patient, modality: modality }
      end

      # rubocop:disable Metrics/AbcSize
      def update
        modality = patient.modalities.find(params[:id])
        authorize modality
        modality.assign_attributes(modality_params)

        if modality.ended_on.present?
          modality.state = "terminated"
        end

        if modality.ended_on.blank? && # from params
           modality.state == "terminated" && # from db
           patient.modalities.order(started_on: :desc).first == modality

          modality.state = "current"
        end

        if modality.save_by(current_user)
          handle_valid_modality
        else
          flash.now[:error] = failed_msg_for("modality")
          render :edit, locals: { patient: patient, modality: modality }
        end
      end
      # rubocop:enable Metrics/AbcSize

      private

      # We allow 0 or 1 days difference between the end and start dates of successive
      # modalities. Anything more than that and we add a warning to the array we return, and this
      # gets displayed.
      # Note we are iterate over modalities in reverse chronological order here, newest first, so,
      # first time in, next_modality is nil, and on the second iteration, next_modality is the next
      # modality in the future etc.
      #
      def modalities_with_noncontiguous_warnings_inserted
        next_modality = nil
        patient_modalities.to_a.each_with_object([]) do |modality, rows|
          if next_modality && modality.ended_on
            days_missing = (next_modality.started_on - modality.ended_on).to_i
            if days_missing > 0
              rows << "Missing modality data between #{I18n.l(modality.ended_on)} and " \
                      "#{I18n.l(next_modality.started_on)} (#{pluralize(days_missing, 'day')})"
            elsif days_missing < 0
              rows << "Overlapping modality dates #{I18n.l(modality.ended_on)} and " \
                      "#{I18n.l(next_modality.started_on)} (#{pluralize(days_missing.abs, 'day')})"
            end
          end
          rows << modality
          next_modality = modality
        end
      end

      def patient_modalities
        patient
          .modalities
          .includes(%i(description created_by change_type source_hospital_centre))
          .ordered
      end

      def delete_current_modality_and_make_previous_one_current(modality_to_delete)
        Modality.transaction do
          previous_modality = patient
            .modalities
            .where(started_on: ...modality_to_delete.started_on)
            .order(started_on: :desc)
            .first
          previous_modality&.update_by(current_user, ended_on: nil, state: :current)
          modality_to_delete.destroy!
        end
      end

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
        params
          .require(:modality)
          .permit(:description_id, :change_type_id, :notes, :started_on, :ended_on,
                  :destination_hospital_centre_id, :source_hospital_centre_id)
      end

      # TODO: refactor
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
    end
  end
end
