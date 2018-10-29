# frozen_string_literal: true

xml = builder

xml.DialysisSession(
  start: session.start_datetime&.to_datetime,
  stop: session.stop_datetime&.to_datetime
) do

  xml.ProcedureType do
    xml.CodingStandard "SNOMED"
    xml.Code "19647005"
    xml.Description "Plasma Exchange"
  end
  xml.ExternalId session.uuid
  xml.QHD19 session.had_intradialytic_hypotension?
  xml.QHD20 session.access_type
  xml.QHD21 session.access_side
  # xml.QHD22 # Access in two sites simultaneously
  xml.QHD30 session.blood_flow
  xml.QHD31 session.duration_in_minutes # Time Dialysed in Minutes
  xml.QHD32 session.sodium_content # Sodium in Dialysate
  # xml.QHD33 # Needling Method

  xml.Clinician do
    xml.Description session.updated_by
  end

  xml.ProcedureTime session.start_datetime&.strftime("%Y%m%d%H%M") # CCYYMMDDhhmm

  xml.EnteredBy do
    xml.CodingStandard "LOCAL"
    xml.Code session.updated_by_username
    xml.Description session.updated_by
  end

  xml.EnteredAt do
    xml.Code session.hospital_unit_renal_registry_code
  end
end
