# frozen_string_literal: true

require_dependency "renalware/patients"

module Renalware
  module Patients
    class Worry < ApplicationRecord
      include Accountable

      has_paper_trail(
        versions: { class_name: "Renalware::Patients::Version" },
        on: [:create, :update, :destroy]
      )

      belongs_to :patient,
                 class_name: "Renalware::Patient",
                 touch: true

      validates :patient, presence: true, uniqueness: true
    end
  end
end
