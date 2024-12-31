module Renalware
  module Patients
    class Worry < ApplicationRecord
      include Accountable
      include RansackAll

      acts_as_paranoid

      has_paper_trail(
        versions: { class_name: "Renalware::Patients::Version" },
        on: %i(create update destroy)
      )

      belongs_to :patient,
                 class_name: "Renalware::Patient",
                 touch: true

      belongs_to :worry_category,
                 -> { with_deleted },
                 class_name: "Renalware::Patients::WorryCategory",
                 touch: true,
                 counter_cache: true

      validates :patient,
                presence: true,
                uniqueness: { conditions: -> { where(deleted_at: nil) } }
    end
  end
end
