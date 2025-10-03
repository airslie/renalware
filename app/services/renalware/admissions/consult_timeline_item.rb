# frozen_string_literal: true

module Renalware
  class Admissions::ConsultTimelineItem < TimelineItem
    private

    def scope
      Admissions::Consult.eager_load(:patient, :consult_site, :hospital_ward)
    end
  end
end
