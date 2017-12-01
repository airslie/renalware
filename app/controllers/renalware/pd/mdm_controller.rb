require_dependency "renalware/pd"

module Renalware
  module PD
    class MDMController < Renalware::MDMController
      def show
        authorize patient
        mdm_presenter = PD::MDMPresenter.new(patient: patient, view_context: view_context)
        render_show(mdm_presenter: mdm_presenter)
      end
    end
  end
end
