module Renalware
  module Directory
    class Person < ApplicationRecord
      include Personable
      include Accountable

      def self.ransackable_attributes(*) = %w(family_name given_name name title)
      def self.ransackable_associations(*) = %w(address created_by updated_by)

      has_one :address, as: :addressable

      accepts_nested_attributes_for :address

      scope :ordered, -> { order(:family_name, :given_name) }
      scope :with_address, -> { includes(:address) }

      def self.policy_class = BasePolicy

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
