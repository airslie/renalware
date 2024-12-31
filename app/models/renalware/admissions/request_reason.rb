module Renalware
  module Admissions
    class RequestReason < ApplicationRecord
      acts_as_paranoid
      validates :description, presence: true
      scope :ordered, -> { order(description: :asc) }
    end
  end
end
