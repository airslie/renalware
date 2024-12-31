module Renalware
  module Medications
    class PrescriptionTermination < ApplicationRecord
      include Accountable

      belongs_to :prescription, touch: true

      validates :terminated_on,
                timeliness: {
                  type: :date,
                  on_or_after: ->(record) { record.prescription.prescribed_on },
                  before: ->(record) { maximum_allowed_termination_date(record) }
                }

      def self.maximum_allowed_termination_date(record)
        prescription = record.prescription
        period = Renalware.config.auto_terminate_hd_prescriptions_after_period
        if prescription.administer_on_hd? && period.present?
          prescription.prescribed_on + period + 1.day
        else
          100.years.from_now
        end
      end
    end
  end
end
