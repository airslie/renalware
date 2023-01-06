# frozen_string_literal: true

module Renalware
  module PD
    class BagType < ApplicationRecord
      acts_as_paranoid
      extend Enumerize

      scope :ordered, -> { order(manufacturer: :asc, description: :asc) }

      enumerize :glucose_strength, in: { not_applicable: 0, low: 1, medium: 2, high: 3 }

      has_many :bags, class_name: "Renalware::PD::RegimeBag"

      validates :manufacturer, presence: true
      validates :description, presence: true
      validates :glucose_strength, presence: true

      validates :glucose_content,
                numericality: {
                  allow_nil: true,
                  greater_than_or_equal_to: 0,
                  less_than_or_equal_to: 50
                }

      def self.policy_class
        BasePolicy
      end

      def full_description
        [manufacturer, description].join(" ")
      end
    end
  end
end
