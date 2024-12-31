module Renalware::Clinical::ClinicalSteps
  def clinical_patient
    @clinical_patient ||= Renalware::Clinical.cast_patient(patient)
  end
end
