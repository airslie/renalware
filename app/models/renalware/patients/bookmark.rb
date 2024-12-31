module Renalware
  module Patients
    class Bookmark < ApplicationRecord
      include RansackAll
      acts_as_paranoid

      belongs_to :user, class_name: "Renalware::Patients::User"
      # No touch required on patient
      belongs_to :patient, class_name: "Renalware::Patient"

      validates :patient, presence: true
      validates :user, presence: true
      validates :user_id, uniqueness: { scope: [:patient_id, :deleted_at] }

      scope :ordered, -> { order(urgent: :desc, updated_at: :asc) }
    end
  end
end
