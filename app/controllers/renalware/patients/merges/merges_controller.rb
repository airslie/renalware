module Renalware
  module Patients
    module Merges
      class MergesController < BaseController
        def index
          authorize Merge, :index?
          pagy, merges = pagy(Merge.order(created_at: :desc))
          render locals: { merges: merges, pagination: pagy }
        end

        def new
          authorize Merge, :new?
          render locals: { merge: Merge.new }
        end

        def create
          authorize Merge, :create?
          merge = Merge.new(merge_params)

          if merge.save
            MergePatients.call(merge: merge)
            redirect_to patients_merges_path
          else
            render :new, locals: { merge: merge }
          end
        end

        private

        def merge_params
          params.require(:patients_merges_merge).permit(
            :major_patient_id,
            :minor_patient_id,
            :message_type,
            :source
          )
        end
      end
    end
  end
end
