# frozen_string_literal: true

module Renalware
  module Patients
    module_function

    def table_name_prefix = "patient_"

    def self.cast_user(user)
      ActiveType.cast(user, ::Renalware::Patients::User)
    end
  end
end
