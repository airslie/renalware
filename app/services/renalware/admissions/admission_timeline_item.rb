# frozen_string_literal: true

module Renalware
  class Admissions::AdmissionTimelineItem < TimelineItem
    private

    def scope
      Admissions::Admission.eager_load(:hospital_ward)
    end
  end
end
