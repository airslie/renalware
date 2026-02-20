module Renalware
  module HD
    module Sessions
      class PatientQuery
        def initialize(patient:, q: nil)
          @patient = patient
          @q = q || { s: "started_at desc" }
        end

        def call
          search.result
        end

        def search
          @search ||= Session.where(patient: @patient).ransack(@q)
        end
      end
    end
  end
end
