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
    end
  end
end
