# frozen_string_literal: true

module Renalware
  module Accesses
    class NeedlingAssessment < ApplicationRecord
      include Accountable
      belongs_to :patient, class_name: "Renalware::Accesses::Patient"
      validates :difficulty, presence: true
      validates :patient, presence: true
      enum difficulty_type: { easy: "easy", moderate: "moderate", hard: "hard" }

      DIFFICULTY_DESCRIPTONS = {
        easy: "Easy (green)",
        moderate: "Moderate (amber)",
        hard: "Hard (red)"
      }.freeze

      scope :ordered, -> { order(created_at: :desc) }

      def self.latest
        ordered.first
      end

      def self.difficulty_type_collection_options
        difficulty_types.keys.map { |key|
          [DIFFICULTY_DESCRIPTONS[key.to_sym], key, { class: key }]
        }
      end

      def difficulty_description
        DIFFICULTY_DESCRIPTONS[difficulty.to_sym]
      end
    end
  end
end
