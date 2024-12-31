module Renalware
  module Letters
    class Letterhead < ApplicationRecord
      validates :name, presence: true
      validates :unit_info, presence: true
      validates :trust_name, presence: true
      validates :trust_caption, presence: true
      belongs_to :hospital_department, class_name: "Hospitals::Department"

      scope :ordered, -> { order(name: :asc) }
    end
  end
end
