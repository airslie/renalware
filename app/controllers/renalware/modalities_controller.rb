module Renalware
  class ModalitiesController < BaseController

    before_filter :load_patient

    def new
      @modality = Modality.new(patient: @patient)
    end

    def index
      @modalities = @patient.modalities.with_deleted.ordered
    end

    def create
      @patient.set_modality(modality_params)

      if @patient.modality_code.death?
        redirect_to edit_patient_death_path(@patient),
          notice: "Please make sure to update patient date of death and cause of death!"
      else
        redirect_to patient_modalities_path(@patient)
      end
    end

    private

    def modality_params
      params.require(:modality).permit(
        :modality_code_id, :modality_change_type,
        :modality_reason_id, :notes, :started_on
      )
    end
  end
end
