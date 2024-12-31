module Renalware
  module Patients
    class WorryCategory < ApplicationRecord
      include Accountable
      acts_as_paranoid
      validates :name, presence: true, uniqueness: true

      def to_s = name
    end
  end
end
