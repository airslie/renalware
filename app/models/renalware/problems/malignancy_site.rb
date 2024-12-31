module Renalware
  module Problems
    class MalignancySite < ApplicationRecord
      validates :description, presence: true, uniqueness: true
      scope :ordered, -> { order(:description) }
    end
  end
end
