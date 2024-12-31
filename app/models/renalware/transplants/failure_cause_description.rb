module Renalware
  module Transplants
    class FailureCauseDescription < ApplicationRecord
      belongs_to :group, class_name: "FailureCauseDescriptionGroup"

      scope :ordered, -> { order(name: :asc) }

      validates :name, presence: true

      def to_s = name
    end
  end
end
