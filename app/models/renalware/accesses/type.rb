module Renalware
  module Accesses
    class Type < ApplicationRecord
      validates :name, presence: true
      delegate :to_s, to: :name

      scope :ordered, -> { order(:name) }
      scope :having_abbreviation, -> { where.not(abbreviation: nil) }
      scope :relevant_to_access_profiles, lambda {
        where(hd_vascular: true)
          .where.not(rr02_code: nil)
          .ordered
      }

      def long_name
        abbrev = abbreviation && " (#{abbreviation})"
        "#{name}#{abbrev}"
      end
    end
  end
end
