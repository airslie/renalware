# frozen_string_literal: true

module Renalware
  module Medications
    class PrescriptionTermination < ApplicationRecord
      include Accountable

      belongs_to :prescription, touch: true

      validates :terminated_on,
                timeliness: {
                  type: :date,
                  on_or_after: ->(record) { record.prescription.prescribed_on }
                }
    end
  end
end
