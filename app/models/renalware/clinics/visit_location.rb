module Renalware
  module Clinics
    class VisitLocation < ApplicationRecord
      include Accountable
      acts_as_paranoid

      has_paper_trail(
        versions: { class_name: "Renalware::Clinics::Version" },
        on: %i(create update destroy)
      )
      validates :name, presence: true, uniqueness: true

      def to_s = name
    end
  end
end
