module Renalware
  module Accesses
    class CatheterInsertionTechnique < ApplicationRecord
      validates :code, presence: true
      validates :description, presence: true
      scope :ordered, -> { order(:description) }
      delegate :to_s, to: :description
    end
  end
end
