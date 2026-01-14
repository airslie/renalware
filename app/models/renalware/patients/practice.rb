module Renalware
  module Patients
    class Practice < ApplicationRecord
      has_one :address, as: :addressable
      has_many :practice_memberships, dependent: :restrict_with_exception
      has_many :primary_care_physicians, through: :practice_memberships

      accepts_nested_attributes_for :address, allow_destroy: true

      validates :name, presence: true
      validates :address, presence: true
      validates :code, presence: true

      def default_primary_care_physician
        gp = primary_care_physicians.find_by(
          patient_practice_memberships: { default_gp: true }
        )
        if gp.nil?
          gp = PrimaryCarePhysician.generic
          practice_memberships.create!(primary_care_physician: gp, default_gp: true)
        end
        gp
      end
    end
  end
end
