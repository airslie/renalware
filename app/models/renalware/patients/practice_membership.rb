module Renalware
  module Patients
    class PracticeMembership < ApplicationRecord
      acts_as_paranoid

      belongs_to :practice
      belongs_to :primary_care_physician
    end
  end
end
