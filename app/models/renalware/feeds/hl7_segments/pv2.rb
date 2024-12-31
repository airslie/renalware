module Renalware
  module Feeds
    module HL7Segments
      # PatientVisit2 segment
      class PV2 < SimpleDelegator
        def expected_admit_date
          Time.zone.parse(super) if super.present?
        end
      end
    end
  end
end
