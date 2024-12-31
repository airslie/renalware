module Renalware
  module Transplants
    class InvestigationType < ApplicationRecord
      acts_as_paranoid
      validates :code,
                presence: true,
                uniqueness: { conditions: -> { where(deleted_at: nil) } }
      validates :description, presence: true
    end
  end
end
