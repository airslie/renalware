# frozen_string_literal: true

module Renalware
  module Directory
    class Person < ApplicationRecord
      include Personable
      include Accountable

      has_one :address, as: :addressable

      accepts_nested_attributes_for :address

      scope :ordered, -> { order(:family_name, :given_name) }
      scope :with_address, -> { includes(:address) }

      def self.policy_class
        BasePolicy
      end

      def self.build(attributes = {})
        person = new(attributes)
        person.build_address
        person
      end

      def to_s
        [family_name, given_name].compact.join(", ")
      end
    end
  end
end
