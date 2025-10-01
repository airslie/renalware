# frozen_string_literal: true

module Renalware
  class Admissions::ConsultTimelineRow < TimelineRow
    private

    def type = TableCell { "Consult" }

    def description
      TableCell do
        "AKI Risk: #{@record.aki_risk&.text}"
      end
    end

    def detail
      TableDetailRow(COLUMNS) do
        div(class: "quick-preview") do
          render Admissions::ConsultDetail.new(@record)
        end
      end
    end
  end
end
