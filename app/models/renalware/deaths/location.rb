module Renalware
  module Deaths
    class Location < ApplicationRecord
      validates :name, presence: true, uniqueness: { case_sensitive: false }
      acts_as_paranoid
      before_validation { self.name = name&.strip }
      scope :ordered, -> { order(:name) }

      def self.policy_class = BasePolicy
      def to_s = name
    end
  end
end
