# Here is where we configure the settings for the Renalware::Core engine.
Renalware.configure do |config|
  config.patient_hospital_identifiers = {
    KCH: :local_patient_id,
    QEH: :local_patient_id_2,
    DVH: :local_patient_id_3,
    PRUH: :local_patient_id_4,
    GUYS: :local_patient_id_5
  }

  # Wire up extra listener to handle letter events
  map = config.broadcast_subscription_map
  map["Renalware::Letters::ApproveLetter"] << "LetterListener"
  map["Renalware::Events::CreateEvent"] << "EventListener"
  map["Renalware::Pathology::CreateObservationRequests"] << "PathologyListener"

  config.ukrdc_sending_facility_name = "Test"
  config.site_name = "Renalware"
  config.batch_printing_enabled = true
  config.disable_inputs_controlled_by_tissue_typing_feed = false
  config.disable_inputs_controlled_by_demographics_feed = false
  config.enforce_user_prescriber_flag = true
  config.allow_uploading_patient_attachments = true
  config.hl7_patient_locator_strategy[:oru] = :dob_and_any_nhs_or_assigning_auth_number
  config.hl7_patient_locator_strategy[:adt] = :dynamic
  config.max_batch_print_size = 50
  # leave patient_visibility_restrictions as :none as demo setting is used on the demo site.
  config.patient_visibility_restrictions = :none # or :by_site_and_research_study or :by_site
  config.allow_qr_codes_in_letters = true
  config.process_hl7_via_raw_messages_table = true
  config.allow_modality_history_amendments = true

  config.send_gp_letters_over_mesh = true
  config.mesh_organisation_ods_code = "RAJ01"
  config.mesh_organisation_uuid = "36944886-8c9b-4ada-b15d-500bff58e018"
  config.mesh_itk_organisation_uuid = "36944886-8c9b-4ada-b15d-500bff58e018"
end
