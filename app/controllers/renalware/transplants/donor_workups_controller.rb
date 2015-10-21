module Renalware
  module Transplants
    class DonorWorkupsController < BaseController
      before_filter :load_patient

      def show
        @workup = DonorWorkup.for_patient(@patient).first_or_initialize
        authorize @workup
        redirect_to edit_patient_transplants_donor_workup_path(@patient) if @workup.new_record?
      end

      def edit
        @workup = DonorWorkup.for_patient(@patient).first_or_initialize
        authorize @workup
      end

      def update
        @workup = DonorWorkup.for_patient(@patient).first_or_initialize
        authorize @workup

        if @workup.update_attributes(workup_params)
          redirect_to patient_transplants_donor_workup_path(@patient)
        else
          render :edit
        end
      end

      protected

      def workup_params
        document_attributes = params.require(:transplants_donor_workup)
          .fetch(:document, nil).try(:permit!)
        params.require(:transplants_donor_workup).permit.merge(document: document_attributes)
      end
    end
  end
end
