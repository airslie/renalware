module Renalware
  module HD
    class Profile < ApplicationRecord
      include Document::Base
      include PatientScope
      include Accountable
      include Supersedeable
      include RansackAll

      belongs_to :patient, touch: true
      belongs_to :hospital_unit, class_name: "Hospitals::Unit"
      belongs_to :dialysate
      belongs_to :prescriber, class_name: "User"
      belongs_to :transport_decider, class_name: "User"
      belongs_to :schedule_definition
      has_document class_name: "Renalware::HD::ProfileDocument"

      # Virtual attr to allow us to accept this field in the profile form, but save it to
      # the patient record rather than to hd_profile
      attr_accessor :named_nurse_id

      has_paper_trail(
        versions: { class_name: "Renalware::HD::Version" },
        on: [:create, :update, :destroy]
      )

      validates :patient, presence: true
      validates :prescriber, presence: true
      validates :home_machine_identifier,
                uniqueness: { case_sensitive: false },
                if: -> { deactivated_at.nil? && home_machine_identifier.present? }

      delegate :hospital_centre, to: :hospital_unit, allow_nil: true

      scope :ordered, -> { order(deactivated_at: :desc) }
      scope :current, -> { ordered.where(deactivated_at: nil).limit(1) }
      scope :dialysing_at_unit, ->(unit_id) { where(hospital_unit_id: unit_id) }

      def self.policy_class = BasePolicy
    end
  end
end
