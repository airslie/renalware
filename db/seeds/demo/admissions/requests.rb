module Renalware
  Rails.benchmark "Creating Admission::Requests" do
    patient_ids = Patient.order("RANDOM()").limit(30).pluck(:id).uniq
    hospital_unit_ids = Hospitals::Unit.pluck(:id)
    reason_ids = Renalware::Admissions::RequestReason.pluck(:id)
    user_ids = User.limit(10).pluck(:id)

    requests = patient_ids.map do |patient_id|
      {
        patient_id: patient_id,
        hospital_unit_id: hospital_unit_ids.sample,
        reason_id: reason_ids.sample,
        notes: "Some notes",
        priority: Renalware::Admissions::Request.priority.values.sample,
        position: 1,
        updated_by_id: user_ids.sample,
        created_by_id: user_ids.sample,
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end

    Admissions::Request.insert_all(requests)
  end
end
