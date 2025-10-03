# frozen_string_literal: true

module Renalware
  class Clinics::ClinicVisitDetail < Detail
    def view_template
      super do
        DetailItem(record, :location)
        DetailItem(record, :notes)
        DetailItem(record, :admin_notes)
      end
    end
  end
end
