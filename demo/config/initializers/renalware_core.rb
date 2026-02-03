# Here is where we configure the settings for the Renalware::Core engine.
Renalware.configure do |config|
  # Wire up extra listener to handle letter events
  # TODO: Consider moving this to a Railtie within Renalware::Letters
  map = config.broadcast_subscription_map
  map["Renalware::Letters::ApproveLetter"] << "LetterListener"
  map["Renalware::Letters::DeleteLetter"] << "LetterListener"
  map["Renalware::Events::CreateEvent"] << "EventListener"
  map["Renalware::Pathology::CreateObservationRequests"] << "PathologyListener"

  config.ukrdc_sending_facility_name = "Test"
  config.site_name = "Renalware"

  # config.enable_allergies = false # Control display of allergies in UI (Imperial sets to false)
  config.hl7_patient_locator_strategy[:oru] = :dob_and_any_nhs_or_assigning_auth_number
  config.hl7_patient_locator_strategy[:adt] = :dynamic

  # leave patient_visibility_restrictions as :none as demo setting is used on the demo site.
  config.patient_visibility_restrictions = :none # or :by_site_and_research_study or :by_site

  config.mesh_organisation_ods_code = "RAJ01"
  config.mesh_organisation_uuid = "36944886-8c9b-4ada-b15d-500bff58e018"
  config.mesh_itk_organisation_uuid = "36944886-8c9b-4ada-b15d-500bff58e018"
end
