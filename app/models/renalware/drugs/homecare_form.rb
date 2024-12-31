module Renalware
  module Drugs
    class HomecareForm < ApplicationRecord
      belongs_to :drug_type, class_name: "Drugs::Type"
      belongs_to :supplier, class_name: "Drugs::Supplier"
      validates :form_name, presence: true
      validates :form_version, presence: true
      validates :prescription_durations, presence: true # an Array of Integers
      validates :prescription_duration_unit, presence: true # e.g. 'month'
    end
  end
end
