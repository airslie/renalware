module Renalware
  module Clinics
    class RememberedClinicVisitPreferences < RememberedPreferences
      SESSION_KEY = :clinic_visit_preferences
      ATTRIBUTES_TO_REMEMBER = %i(date clinic_id).freeze
    end
  end
end
