# frozen_string_literal: true

module Renalware
  class Transplants::OfferDetail < Detail
    def view_template
      super do
        DetailItem(document, :donor_id, label: "Donor ID")
        DetailItem(record, :description)
        DetailItem(record, :notes)
      end
    end
  end
end
