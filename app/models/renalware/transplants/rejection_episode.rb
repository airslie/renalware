module Renalware
  module Transplants
    class RejectionEpisode < ApplicationRecord
      include Accountable
      has_paper_trail(
        versions: { class_name: "Renalware::Transplants::Version" },
        on: [:create, :update, :destroy]
      )
      belongs_to :followup, class_name: "RecipientFollowup", touch: true
      belongs_to :treatment, class_name: "RejectionTreatment"
      validates :recorded_on, presence: true
      validates :notes, presence: true
      validates :followup,    presence: true, if: proc { |re| re.followup_id.blank? }
      validates :followup_id, presence: true, if: proc { |re| re.followup.blank? }
      scope :ordered, -> { order(:recorded_on, :created_at) }
    end
  end
end
