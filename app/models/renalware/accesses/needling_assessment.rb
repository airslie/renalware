module Renalware
  module Accesses
    class NeedlingAssessment < ApplicationRecord
      include Accountable
      belongs_to :patient, class_name: "Renalware::Accesses::Patient"
      validates :difficulty, presence: true
      validates :patient, presence: true
      enum :difficulty, { easy: "easy", moderate: "moderate", hard: "hard" }

      # access_needling_assessment_difficulties

      DIFFICULTY_DESCRIPTIONS = {
        easy: "Easy (green)",
        moderate: "Moderate (amber)",
        hard: "Hard (red)"
      }.freeze

      scope :ordered, -> { order(created_at: :desc) }

      def self.latest
        ordered.first
      end

      def self.difficulty_type_collection_options
        difficulties.keys.map { |key|
          [DIFFICULTY_DESCRIPTIONS[key.to_sym], key, { class: key }]
        }
      end

      def difficulty_description
        DIFFICULTY_DESCRIPTIONS[difficulty.to_sym]
      end
    end
  end
end
