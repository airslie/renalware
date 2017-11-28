require_dependency "renalware/renal"

module Renalware
  module Renal
    module LowClearance
      class MDMPatientsController < Renalware::MDMPatientsController
        def index
          render_index(query: query,
                       page_title: t(".page_title"),
                       view_proc: ->(patient) { patient_renal_low_clearance_mdm_path(patient) })
        end

        private

        def query
          @query ||= MDMPatientsQuery.new(q: q, named_filter: named_filter)
        end

        def named_filter
          params[:named_filter]
        end

        def q
          params[:q]
        end
      end
    end
  end
end
