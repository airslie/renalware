module Renalware
  module Patients
    class Abridgement < ApplicationRecord
      self.table_name = "patient_master_index"
      validates :hospital_number, presence: true
      validates :given_name, presence: true
      validates :family_name, presence: true

      def self.policy_class = ::Renalware::BasePolicy
    end
  end
end
