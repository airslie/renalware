# frozen_string_literal: true

module Renalware
  class Events::InvestigationDetail < Detail
    def view_template
      super do
        DetailItem(document, :modality)
        DetailItem(document, :type)
        DetailItem(document, :result)
        DetailItem(record, :notes)
      end
    end
  end
end
