module Renalware
  module Transplants
    class RecipientFollowup < ApplicationRecord
      include Document::Base
      extend Enumerize

      enumerize :graft_function_onset, in: %w(immediate delayed primary_non_function)

      belongs_to :operation,
                 class_name: "RecipientOperation",
                 touch: true
      belongs_to :transplant_failure_cause_description,
                 class_name: "Transplants::FailureCauseDescription"
      has_many :rejection_episodes,
               class_name: "RejectionEpisode",
               dependent: :restrict_with_exception,
               foreign_key: "followup_id",
               inverse_of: :followup

      accepts_nested_attributes_for :rejection_episodes,
                                    reject_if: :all_blank,
                                    allow_destroy: true

      has_paper_trail(
        versions: { class_name: "Renalware::Transplants::Version" },
        on: [:create, :update, :destroy]
      )

      has_document class_name: "Renalware::Transplants::RecipientFollowupDocument"

      validates :stent_removed_on, timeliness: { type: :date, allow_blank: true }
      validates :graft_nephrectomy_on, timeliness: { type: :date, allow_blank: true }
      validates :transplant_failed_on, timeliness: { type: :date, allow_blank: true }
      validates :transplant_failed_on,
                presence: true,
                if: ->(o) { o.transplant_failed }
      validates :transplant_failure_cause_description_id,
                presence: true,
                if: ->(o) { o.transplant_failed }
      validates :transplant_failure_cause_other,
                presence: true,
                if: ->(o) { o.transplant_failure_cause_description.try(:name) == "Other" }
    end
  end
end
