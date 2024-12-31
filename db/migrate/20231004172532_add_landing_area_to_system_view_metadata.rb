class AddLandingAreaToSystemViewMetadata < ActiveRecord::Migration[7.0]
  def change
    within_renalware_schema do
      create_enum :enum_patient_landing_page, %w(
        accesses
        admissions
        akcc
        clinic_visits
        clinical
        clinical_summary
        demographics
        events
        hd
        letters
        low_clearance
        modalities
        pathology
        pd
        prescriptions
        problems
        renal
        transplants_donor
        transplants_recipient
        virology
      )
      add_column(
        :system_view_metadata,
        :patient_landing_page,
        :enum_patient_landing_page,
        comment: "If present, any patient links generated the report associated with this " \
                 "row will take the user indicated landing area eg patients/123/hd, where these " \
                 "landing areas are routes defined by each RW module and often redirect, e.g. to " \
                 "a dashboard or profile page"
      )
    end
  end
end
