# frozen_string_literal: true

module Renalware
  patient = Patient.find_by(family_name: "RABBIT", given_name: "Roger")

  log "Adding Prescriptions for #{patient}" do
    barts_doc = User.find_by!(username: "bartsdoc")

    patient.prescriptions.create!(
      drug_id: 296, # ESA
      treatable: patient,
      dose_amount: "25",
      dose_unit: "milligram",
      medication_route: Medications::MedicationRoute.find_by(name: "Oral"),
      frequency: "nocte",
      prescribed_on: "2014-10-10",
      provider: 2,
      by: barts_doc
    )

    patient.prescriptions.create!(
      drug_id: 208, # Immunosuppressant
      treatable: patient,
      dose_amount: "100",
      dose_unit: "milligram",
      medication_route: Medications::MedicationRoute.find_by(name: "Oral"),
      frequency: "bd",
      prescribed_on: "2015-06-16",
      provider: 0,
      by: barts_doc
    )

    patient.prescriptions.create!(
      drug_id: 126,
      treatable: patient.peritonitis_episodes.first!,
      dose_amount: "100",
      dose_unit: "milligram",
      medication_route: Medications::MedicationRoute.find_by(name: "Oral"),
      frequency: "tid for 7d",
      prescribed_on: "2015-09-21",
      provider: 0,
      by: barts_doc
    )

    patient.prescriptions.create!(
      drug_id: 208, # Immunosuppressant
      treatable: patient,
      dose_amount: "50",
      dose_unit: "milligram",
      medication_route: Medications::MedicationRoute.find_by(name: "Oral"),
      frequency: "bd for 7 days",
      prescribed_on: "2015-09-13",
      provider: 0, by: barts_doc,
      termination: Medications::PrescriptionTermination.new(
        terminated_on: "2015-09-20",
        by: barts_doc
      )
    )
  end
end
