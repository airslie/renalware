# frozen_string_literal: true

# Here is where we configure the settings for the Renalware::Core engine.

require_dependency "renalware"

Renalware.configure do |config|
  config.patient_hospital_identifiers = {
    KCH: :local_patient_id,
    QEH: :local_patient_id_2,
    DVH: :local_patient_id_3,
    PRUH: :local_patient_id_4,
    GUYS: :local_patient_id_5
  }

  # Wire up extra listener listener to handle letter events
  map = config.broadcast_subscription_map
  map["Renalware::Letters::ApproveLetter"] << "LetterListener"
  map["Renalware::Pathology::CreateObservationRequests"] << "PathologyListener"

  config.ukrdc_sending_facility_name = "Test"
  config.site_name = "Renalware"
  config.batch_printing_enabled = true
  config.disable_inputs_controlled_by_tissue_typing_feed = false
  config.disable_inputs_controlled_by_demographics_feed = false
  config.enforce_user_prescriber_flag = false
end

# Renalware::Patients.configure
# Renalware::Pathology.configure
