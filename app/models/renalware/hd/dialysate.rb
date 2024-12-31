module Renalware
  module HD
    class Dialysate < ApplicationRecord
      acts_as_paranoid
      validates :name, presence: true, uniqueness: true
      validates :sodium_content, presence: true, numericality: true
      validates :sodium_content_uom, presence: true
      validates :bicarbonate_content, numericality: true, allow_blank: true
      validates :calcium_content, numericality: true, allow_blank: true
      validates :glucose_content, numericality: true, allow_blank: true
      validates :potassium_content, numericality: true, allow_blank: true

      def to_s = name
    end
  end
end
