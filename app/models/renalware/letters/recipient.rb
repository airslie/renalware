require_dependency "renalware/letters"

module Renalware
  module Letters
    class Recipient < ActiveRecord::Base
      belongs_to :letter
      belongs_to :source, polymorphic: true
      has_one :address, as: :addressable

      accepts_nested_attributes_for :address, reject_if: :address_not_needed?, allow_destroy: true

      after_initialize :apply_defaults, if: :new_record?

      def to_s
        name
      end

      def copy_address!(address)
        build_address if address.blank?
        address.copy_from(address).save!
      end

      private

      def address_not_needed?
        source_type.present?
      end

      def apply_defaults
        self.source_type ||= Doctor.name
      end
    end
  end
end
