# frozen_string_literal: true

module Renalware
  class Events::BiopsyDetail < Detail
    def view_template
      super do
        DetailItem(document, :result1)
        DetailItem(document, :result2)
        DetailItem(record, :notes)
      end
    end
  end
end
