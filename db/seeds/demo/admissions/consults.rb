module Renalware
  Rails.benchmark "Creating Admission::Consults" do
    patient_ids = Patient.order("RANDOM()").limit(40).pluck(:id).uniq
    hospital_ward_ids = Hospitals::Ward.pluck(:id)
    consult_site_ids = Renalware::Admissions::ConsultSite.pluck(:id)
    users = User.limit(10).select(:id)

    consults = patient_ids.map do |patient_id|
      started_on = (rand * 100).days.ago
      ended_on = [started_on, nil]

      {
        patient_id: patient_id,
        consult_site_id: consult_site_ids.sample,
        hospital_ward_id: hospital_ward_ids.sample,
        seen_by_id: users.sample.id,
        started_on: started_on,
        ended_on: ended_on.sample,
        decided_on: started_on,
        rrt: [true, false].sample,
        transfer_priority: Admissions::Consult.transfer_priority.values.sample,
        aki_risk: Admissions::Consult.aki_risk.values.sample,
        consult_type: "n/a",
        contact_number: "-",
        requires_aki_nurse: [true, false].sample,
        description: "Some notes",
        updated_by_id: users.sample.id,
        created_by_id: users.sample.id,
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end

    Admissions::Consult.insert_all(consults)
  end
end
