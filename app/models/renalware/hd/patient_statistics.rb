module Renalware
  module HD
    class PatientStatistics < ApplicationRecord
      include PatientScope

      belongs_to :patient, class_name: "Renalware::Patient"
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"

      validates :hospital_unit, presence: true
      validates :patient,
                presence: true,
                uniqueness: { scope: [:month, :year] }

      validates :month,
                numericality: true,
                inclusion: 1..12,
                allow_nil: true

      validates :month, presence: true, unless: :rolling?
      validates :year, presence: true, unless: :rolling?

      validates :year,
                numericality: true,
                inclusion: 1970..2100,
                allow_nil: true

      validates :rolling,
                inclusion: { in: [true, nil] }

      validates :session_count, presence: true, numericality: true

      scope :ordered, lambda {
        order(:rolling, year: :desc, month: :desc)
      }

      scope :rolling, -> { where(rolling: true) }

      def to_s
        return "Last #{session_count} sessions" if rolling?

        if year > 0 && month > 0
          Date.new(year, month).strftime("%b %Y")
        end
      end
    end
  end
end
