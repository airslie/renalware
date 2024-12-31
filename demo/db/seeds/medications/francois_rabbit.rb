module Renalware
  patient = Patient.find_by(family_name: "RABBIT", given_name: "François")

  Rails.benchmark "Adding Prescriptions for #{patient}" do
    barts_doc = User.find_by!(username: "bartsdoc")

    patient.prescriptions.create!(
      drug_id: 183,
      treatable: patient,
      dose_amount: "25",
      dose_unit: "milligram",
      medication_route_id: 1,
      frequency: "nocte",
      prescribed_on: "2014-10-10",
      provider: 0,
      administer_on_hd: true,
      by: barts_doc
    )

    patient.prescriptions.create!(
      drug_id: 269,
      treatable: patient,
      dose_amount: "100",
      dose_unit: "milligram",
      medication_route_id: 1,
      frequency: "bd",
      prescribed_on: "2015-06-16",
      provider: 0,
      administer_on_hd: true,
      by: barts_doc
    )

    patient.prescriptions.create!(
      drug_id: 986,
      treatable: patient,
      dose_amount: "50",
      dose_unit: "milligram",
      medication_route_id: 1,
      frequency: "bd for 7 days",
      prescribed_on: "2015-09-13",
      provider: 0, by: barts_doc,
      administer_on_hd: true,
      termination: Medications::PrescriptionTermination.new(
        terminated_on: "2015-09-20",
        by: barts_doc
      )
    )
  end
end
