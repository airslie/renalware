# frozen_string_literal: true

module Renalware
  class Events::AdvancedCarePlanDetail < Detail
    def view_template
      super do
        DetailItem(document, :state)
        DetailItem(record, :notes)
      end
    end
  end
end
