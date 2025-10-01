# frozen_string_literal: true

module Renalware
  class Events::ClinicalFrailtyScoreDetail < Detail
    def view_template
      super do
        DetailItem(document, :score)
        DetailItem(record, :notes)
      end
    end
  end
end
