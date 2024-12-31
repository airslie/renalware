module Renalware
  module Admissions
    class Specialty < ApplicationRecord
      validates :name, presence: true, uniqueness: true

      scope :ordered, -> { order(position: :asc) }

      def to_s = name
    end
  end
end
