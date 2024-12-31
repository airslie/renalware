module Renalware
  module ClinicalHelper
    def clinical_profile_breadcrumb(patient)
      breadcrumb_for("Clinical Profile", patient_clinical_profile_path(patient))
    end
  end
end
