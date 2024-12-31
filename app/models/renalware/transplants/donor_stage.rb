module Renalware
  module Transplants
    class DonorStage < ApplicationRecord
      include Accountable
      include PatientScope
      include RansackAll

      belongs_to :patient, class_name: "Renalware::Patient", touch: true
      belongs_to :stage_position, class_name: "DonorStagePosition"
      belongs_to :stage_status, class_name: "DonorStageStatus"
      validates :patient, presence: true
      validates :stage_position, presence: true
      validates :stage_status, presence: true
      validates :started_on, presence: true

      scope :current, -> { where(terminated_on: nil) }
      scope :ordered, -> { order(terminated_on: :desc, started_on: :desc) }
    end
  end
end
