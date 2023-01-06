# frozen_string_literal: true

module Renalware
  module Transplants
    class FailureCauseDescriptionGroup < ApplicationRecord
      has_many :descriptions, class_name: "FailureCauseDescription", foreign_key: "group_id"

      def ordered_descriptions
        descriptions.ordered
      end

      def to_s
        name
      end
    end
  end
end
