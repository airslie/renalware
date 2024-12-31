module Renalware
  module Transplants
    class Donation < ApplicationRecord
      include PatientScope
      extend Enumerize

      belongs_to :patient, touch: true
      belongs_to :recipient, class_name: "Patient", touch: true

      has_paper_trail(
        versions: { class_name: "Renalware::Transplants::Version" },
        on: [:create, :update, :destroy]
      )

      scope :ordered, -> { order(created_at: :asc) }
      scope :reversed, -> { order(created_at: :desc) }
      scope :for_recipient, ->(recipient) { where(recipient_id: recipient.id) }

      enumerize :state, in: %i(volunteered seen_in_clinic investigating handed_over unsuitable)
      enumerize :relationship_with_recipient, in: %i(
        son_or_daughter mother_or_father sibling_2_shared
        sibling_1_shared sibling_0_shared sibling
        monozygotic_twin dizygotic_twin other_living_related
        living_non_related_spouse living_non_related_partner
        pooled_paired altruistic_non_directed other_living_non_related
      )
      enumerize :blood_group_compatibility, in: %i(yes no)
      enumerize :paired_pooled_donation, in: %i(
        n_a information_given consented to_enroll_in_next_matching_un
      )

      validates :state, presence: true
      validates :relationship_with_recipient, presence: true
      validates :relationship_with_recipient_other,
                presence: true,
                if: ->(o) { o.relationship_with_recipient.try(:other_living_non_related?) }
      validates :volunteered_on, timeliness: { type: :date, allow_blank: true }
      validates :first_seen_on, timeliness: { type: :date, allow_blank: true }
      validates :workup_completed_on, timeliness: { type: :date, allow_blank: true }
      validates :donated_on, timeliness: { type: :date, allow_blank: true }
      validate :validate_recipient

      def self.policy_class = BasePolicy

      private

      def validate_recipient
        if recipient_id.present? && (recipient_id == patient_id)
          errors.add(:recipient_id, :invalid)
        end
      end
    end
  end
end
