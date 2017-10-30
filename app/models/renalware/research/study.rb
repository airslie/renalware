require_dependency "renalware/research"

module Renalware
  module Research
    class Study < ApplicationRecord
      include Accountable
      acts_as_paranoid

      validates :code, presence: true, uniqueness: { scope: :deleted_at }
      validates :description, presence: true
      validates :started_on, timeliness: { type: :date, allow_blank: true }
      validates :terminated_on, timeliness: { type: :date, allow_blank: true, after: :started_on }

      scope :ordered, -> { order(created_at: :asc) }

      has_many :participants, class_name: "StudyParticipant", dependent: :destroy
    end
  end
end
