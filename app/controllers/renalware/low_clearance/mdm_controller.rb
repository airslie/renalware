module Renalware
  module LowClearance
    class MDMController < Renalware::MDMController
      def show
        authorize patient
        presenter = LowClearance::MDMPresenter.new(patient: patient, view_context: view_context)
        render_show(mdm_presenter: presenter)
      end
    end
  end
end
