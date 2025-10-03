# frozen_string_literal: true

module Renalware
  class Modalities::ModalityTimelineRow < TimelineRow
    private

    def row_toggler = TableCell()
    def type = TableCell { "Modality Change" }
    def description = TableCell { @record.description.name }
  end
end
