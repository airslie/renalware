# frozen_string_literal: true

require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class Lab < ApplicationRecord
      has_many :request_descriptions, class_name: "RequestDescription"

      scope :ordered, -> { order(name: :asc) }

      validates :name, presence: true

      def self.unknown
        find_by!(name: "Lab: Unknown")
      end
    end
  end
end
