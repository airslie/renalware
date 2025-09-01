# frozen_string_literal: true

module Renalware
  class Admissions::TimelineRow < TimelineRow
    private

    def type = TableCell { "Admission" }
    def description = TableCell { @record.admission_type&.text }
    def detail = TableDetailRow(COLUMNS) { @record.hospital_ward.name }
  end
end
