module Renalware
  module Transplants
    class FailureCauseDescriptionGroup < ApplicationRecord
      has_many :descriptions,
               class_name: "FailureCauseDescription",
               foreign_key: "group_id",
               dependent: :restrict_with_exception

      def ordered_descriptions
        descriptions.ordered
      end

      def to_s = name
    end
  end
end
