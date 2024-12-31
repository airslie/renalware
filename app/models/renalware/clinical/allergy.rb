module Renalware
  module Clinical
    class Allergy < ApplicationRecord
      include Accountable
      include PatientScope
      acts_as_paranoid
      validates :description, presence: true
      validates :recorded_at, presence: true
      belongs_to :patient, touch: true

      default_scope { order(recorded_at: :desc) }
    end
  end
end
