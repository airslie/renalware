module Renalware
  module Pathology
    class Lab < ApplicationRecord
      UNKNOWN_LAB_NAME = "Lab: Unknown".freeze

      has_many :request_descriptions, class_name: "RequestDescription"

      has_paper_trail(
        versions: { class_name: "Renalware::Pathology::Version" },
        on: [:create, :update, :destroy]
      )

      scope :ordered, -> { order(name: :asc) }

      validates :name, presence: true, uniqueness: true

      def self.unknown
        find_by!(name: UNKNOWN_LAB_NAME)
      end
    end
  end
end
