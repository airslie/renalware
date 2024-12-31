module Renalware
  module Letters
    class ContactDescription < ApplicationRecord
      validates :system_code, presence: true, uniqueness: true
      validates :name, presence: true, uniqueness: true
      validates :position, presence: true, uniqueness: true

      scope :ordered, -> { order(:position) }
      scope :specified, -> { where.not(system_code: UNSPECIFIED_SYSTEM_CODE) }

      UNSPECIFIED_SYSTEM_CODE = "other".freeze

      def self.[](system_code)
        find_by!(system_code: system_code.to_s)
      end

      def unspecified?
        system_code == UNSPECIFIED_SYSTEM_CODE
      end

      def to_s = name
    end
  end
end
