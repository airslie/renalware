module Renalware
  module PD
    class TrainingType < ApplicationRecord
      acts_as_paranoid

      validates :name, presence: true

      scope :ordered, -> { order(:name) }

      def to_s = name
    end
  end
end
