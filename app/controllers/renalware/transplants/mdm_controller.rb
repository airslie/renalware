module Renalware
  module Transplants
    class MDMController < Renalware::MDMController
      def show
        authorize patient
        mdm_presenter = Transplants::MDMPresenter.new(patient: patient, view_context: view_context)
        render_show(mdm_presenter: mdm_presenter)
      end
    end
  end
end
