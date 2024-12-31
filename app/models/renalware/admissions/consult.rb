module Renalware
  module Admissions
    class Consult < ApplicationRecord
      include Accountable
      extend Enumerize
      include PatientsRansackHelper
      include RansackAll

      PRIORITY_VALUES = (1..20)
      validates :patient_id, presence: true
      validates :started_on, presence: true
      validates :description, presence: true
      validates :priority,
                numericality: {
                  only_integer: true,
                  less_than_or_equal_to: PRIORITY_VALUES.last,
                  allow_blank: true
                }

      validates :other_site_or_ward, presence: {
        if: ->(consult) { consult.consult_site_id.blank? && consult.hospital_ward_id.blank? }
      }

      belongs_to :patient, touch: true
      belongs_to :consult_site, class_name: "Admissions::ConsultSite"
      belongs_to :hospital_ward, class_name: "Hospitals::Ward"
      belongs_to :specialty, class_name: "Admissions::Specialty"
      belongs_to :seen_by, class_name: "User"

      enumerize :transfer_priority, in: %i(unknown necessary desirable potential unnecessary)
      enumerize :aki_risk, in: %i(yes no unknown)

      scope :active, -> { where(ended_on: nil) }

      ransacker :priority do
        Arel.sql("coalesce(priority, -1)")
      end
    end
  end
end
