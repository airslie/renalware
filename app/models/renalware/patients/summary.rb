##
# Backed by a SQL view, the patient summary is principally a set of counts for various entities
# which hang off a patient, for example prescriptions_count, problems_count etc.
# These can be used for instance when building the patient navigation.
#
module Renalware
  module Patients
    class Summary < ApplicationRecord
      self.primary_key = :id
    end
  end
end
