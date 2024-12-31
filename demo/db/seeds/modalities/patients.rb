module Renalware
  Rails.benchmark "Adding Random Modalities for non-RABBIT Patients" do
    # Note the RABBIT family have special modalities assigned elsewhere, so skip them here
    patient_ids = Patient.where.not(family_name: "RABBIT").pluck(:id)
    user_id = User.first.id
    modality_description_ids = Modalities::Description.pluck(:id)
    months = (1..36).to_a

    # Remove any current modalities
    Modalities::Modality.where(patient_id: patient_ids).delete_all

    modalities = patient_ids.each.map do |patient_id|
      {
        patient_id: patient_id,
        description_id: modality_description_ids.sample,
        started_on: months.sample.months.ago,
        created_by_id: user_id,
        updated_by_id: user_id,
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end
    Modalities::Modality.insert_all(modalities)
  end
end
