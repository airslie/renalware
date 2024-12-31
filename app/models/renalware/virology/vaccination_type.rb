module Renalware
  module Virology
    class VaccinationType < ApplicationRecord
      include Sortable

      class UniquenessIncludingDeletedValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          return unless record.send(:"#{attribute}_changed?")

          if record.class.default_scoped.with_deleted.exists?(attribute => value)
            record.errors.add attribute, (options[:message] || "already used")
          end
        end
      end

      validates :name, presence: true, uniqueness_including_deleted: true
      validates :code, presence: true, uniqueness_including_deleted: true

      before_save :format_atc_codes
      before_create :underscore_code

      acts_as_paranoid

      scope :ordered, -> { order(deleted_at: :desc, position: :asc, name: :asc) }

      def self.policy_class = BasePolicy

      def underscore_code
        return if code.blank?

        self.code = code.downcase.tr("  ", " ").tr(" ", "_")
      end

      def format_atc_codes
        return if atc_codes.blank?

        self.atc_codes = atc_codes.compact_blank.map(&:upcase)
      end
    end
  end
end
