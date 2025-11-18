module Renalware
  module Patients
    module Merges
      class OperationsController < BaseController
        def index
          authorize Operation, :index?
          render locals: { merge: merge }
        end

        private

        def merge = Merge.find(params[:merge_id])
      end
    end
  end
end
