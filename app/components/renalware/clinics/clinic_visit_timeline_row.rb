# frozen_string_literal: true

module Renalware
  class Clinics::ClinicVisitTimelineRow < TimelineRow
    private

    def description
      TableCell { @record.clinic.name }
    end

    def type
      TableCell do
        dietetics? ? "Dietetic Clinic Visit" : "Clinic Visit"
      end
    end

    def detail
      TableDetailRow(COLUMNS) do
        if dietetics?
          render partial("/renalware/dietetics/clinic_visits/summary", clinic_visit: @record)
        else
          render NameService
            .from_model(@record, to: "Detail")
            .new(@record)
        end
      end
    end

    def dietetics?
      @record.is_a?(Dietetics::ClinicVisit)
    end
  end
end
