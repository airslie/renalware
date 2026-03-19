module Renalware
  Rails.benchmark "Adding demo AKI Alerts" do
    action_ids = Renal::AKIAlertAction.pluck(:id)
    patient_ids = Patient.pluck(:id)
    hospital_ward_ids = Hospitals::Ward.pluck(:id)
    now = Time.zone.now
    dates = [now, now, now - 1.day, now - 1.week, now - 1.month]

    10.times do
      date = dates.sample
      Renal::AKIAlert.create!(
        action_id: action_ids.sample,
        patient_id: patient_ids.sample,
        hospital_ward_id: hospital_ward_ids.sample,
        hotlist: [true, false].sample,
        max_cre: (80..100).to_a.sample,
        cre_date: date - 1.day,
        max_aki: 2,
        aki_date: date - 1.day,
        notes: "Some notes",
        created_at: date,
        updated_at: date
      )
    end
  end
end
