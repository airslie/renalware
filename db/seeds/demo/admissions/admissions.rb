module Renalware
  Rails.benchmark "Creating Admissions::Admission (inpatients)" do
    patients = Renalware::Patient
      .order("RANDOM()")
      .select(:id)
      .joins(:current_modality)
      .includes(:current_modality)
      .limit(20)
    hospital_ward_ids = Hospitals::Ward.pluck(:id)
    user_ids = User.limit(10).pluck(:id)

    admissions = patients.map do |patient|
      admitted_on = (rand * 100).days.ago
      {
        patient_id: patient.id,
        hospital_ward_id: hospital_ward_ids.sample,
        admitted_on: admitted_on,
        admission_type: Admissions::Admission.admission_type.values.sample,
        modality_at_admission_id: patient.current_modality.id,
        reason_for_admission: "Lorem ipsum dolor sit amet.",
        updated_by_id: user_ids.sample,
        created_by_id: user_ids.sample,
        discharge_summary: nil,
        summarised_on: nil,
        discharged_on: nil,
        discharge_destination: nil,
        summarised_by_id: nil,
        destination_notes: nil,
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end

    (admissions.count / 2).times do
      admission = admissions.sample
      admission.update(
        discharge_summary: "Discharge summary",
        summarised_on: admission[:admitted_on] + 2.days,
        discharged_on: admission[:admitted_on] + 2.days,
        discharge_destination: Admissions::Admission.discharge_destination.values.sample,
        summarised_by_id: user_ids.sample,
        destination_notes: <<-NOTES
          Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
          incididunt ut labore et dolore magna aliqua.
        NOTES
      )
    end

    Admissions::Admission.insert_all(admissions)
  end
end
