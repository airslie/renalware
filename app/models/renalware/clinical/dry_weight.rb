require_dependency "renalware/clinical"
require "document/base"

module Renalware
  module Clinical
    class DryWeight < ApplicationRecord
      include PatientScope
      include Accountable

      belongs_to :patient, class_name: "Renalware::Clinical::Patient"
      belongs_to :assessor, class_name: "User", foreign_key: "assessor_id"

      has_paper_trail class_name: "Renalware::Clinical::Version"

      scope :ordered, -> { order(assessed_on: :desc, created_at: :desc) }

      validates :patient, presence: true
      validates :assessor, presence: true
      validates :weight, presence: true, "renalware/patients/weight" => true
      validates :assessed_on, presence: true
      validates :assessed_on, timeliness: { type: :date, allow_blank: false }
    end
  end
end