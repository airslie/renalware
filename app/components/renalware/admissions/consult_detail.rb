# frozen_string_literal: true

module Renalware
  class Admissions::ConsultDetail < Detail
    def view_template
      super do
        DetailItem(record, :created_by, label: "Author")
        DetailItem(record, :patient_current_modality, label: "Modality")
        DetailItem(record, :description)
        DetailItem(record, :e_alert, label: "E-Alert")
        DetailItem(record, :specialty)
        DetailItem(record, :consult_type, label: "Specialty notes")
      end
    end
  end
end
