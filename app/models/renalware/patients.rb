module Renalware
  module Patients
    module_function

    def table_name_prefix = "patient_"
    def self.cast_user(user) = user.becomes(Patients::User)
  end
end
