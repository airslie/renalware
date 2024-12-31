module Renalware
  module Drugs
    class PatientGroupDirection < ApplicationRecord
      validates :name, presence: true
      validates :code, presence: true
      validates :code, uniqueness: { conditions: -> { where(ends_on: nil, deleted_at: nil) } }

      scope :ordered, -> { order(position: :asc, name: :asc) }
      def self.policy_class = BasePolicy
    end
  end
end
