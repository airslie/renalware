# frozen_string_literal: true

module Renalware
  class Clinics::ClinicVisitTimelineItem < TimelineItem
    private

    def scope
      Clinics::ClinicVisit.eager_load(:clinic)
    end
  end
end
