# frozen_string_literal: true

require_dependency "renalware/pd"

module Renalware
  module PD
    class TrainingSite < ApplicationRecord
      acts_as_paranoid

      validates :code, presence: true
      validates :name, presence: true

      scope :ordered, -> { order(:name) }

      def to_s
        name
      end
    end
  end
end
