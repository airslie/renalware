module Renalware
  module Accesses
    class Assessment < ApplicationRecord
      include Document::Base
      include Accountable
      extend Enumerize

      belongs_to :patient, touch: true
      belongs_to :type, class_name: "Type"

      has_document class_name: "Renalware::Accesses::AssessmentDocument"

      has_paper_trail(
        versions: { class_name: "Renalware::Accesses::Version" },
        on: %i(create update destroy)
      )

      scope :ordered, -> { order(performed_on: :desc) }

      validates :type, presence: true
      validates :side, presence: true
      validates :performed_on, presence: true
      validates :performed_on, timeliness: { type: :date, allow_blank: false }
      validates :procedure_on, timeliness: { type: :date, allow_blank: true }

      enumerize :side, in: %i(left right)

      def self.policy_class = BasePolicy
    end
  end
end
