# frozen_string_literal: true

xml = builder

xml.Treatment do
  xml.FromTime modality.started_on
  xml.ToTime modality.ended_on

  xml.HealthCareFacility do
    xml.CodingStandard "ODS"
    xml.Code Renalware.config.ukrdc_site_code
  end

  # xml.AdmitReason do
  #   xml.comment! "AdmitReason 1 == Haemodialysis - TBC - may need to capture/derive"
  #   xml.CodingStandard "CF_RR7_TREATMENT"
  #   xml.Code "1"
  # end

  # xml.EnteredAt do
  #   xml.Code session.hospital_unit_renal_registry_code
  # end

  # xml.Attributes do
  #   xml.HDP01 session.patient&.hd_profile&.schedule_definition&.days_per_week
  #   xml.HDP02 session.duration
  #   xml.HDP03 session.document.dialysis.flow_rate
  #   xml.HDP04 session&.dialysate&.sodium_content
  #   xml.QBL05 session.access_type
  #   xml.comment! "ERF61 - defaulting to 5 if not present, as element is required"
  #   xml.ERF61 patient.current_registration_status_rr_code || "5" # 5= not assessed
  #   xml.PAT35 patient.first_seen_on
  # end
end