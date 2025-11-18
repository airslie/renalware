module Renalware
  module Patients
    module_function

    def table_name_prefix = "patient_"
    def self.cast_user(user) = user.becomes(Patients::User)

    module Merges
      def self.table_name_prefix = "patient_merge_"
    end
  end
end
