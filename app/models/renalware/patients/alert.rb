module Renalware
  module Patients
    class Alert < ApplicationRecord
      include Accountable
      acts_as_paranoid

      attr_accessor :urgency # for use in forms

      validates :patient, presence: true
      validates :notes, presence: true

      belongs_to :patient, touch: true
    end
  end
end
