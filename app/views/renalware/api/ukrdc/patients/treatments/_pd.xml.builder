xml = builder

xml.Treatment do
  xml.EncounterNumber [treatment.modality_id,treatment.pd_regime_id].compact.join("-")
  xml.EncounterType "N"
  xml.FromTime treatment.started_on&.iso8601
  xml.ToTime(treatment.ended_on&.iso8601) if treatment.ended_on.present?

  xml.AdmitReason do
    xml.CodingStandard "CF_RR7_TREATMENT"
    xml.Code treatment.modality_code.txt_code
  end
end
