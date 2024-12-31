module Renalware
  Rails.benchmark "Assigning ESA Prescriptions to Random Patients" do
    # Reference: ESA type drug_ids
    # 296,2
    # 693,2
    # 883,2
    # 884,2
    # 885,2
    # 1635,2

    kch_doc = User.find_by!(username: "kchdoc")
    barts_doc = User.find_by!(username: "bartsdoc")
    start_dates = (60..365).to_a
    term_dates = (1..59).to_a
    esa_drug_ids = [296, 883, 884, 885]
    doses = [1000, 2000, 3000]

    Patient.transaction do
      patients = Patient.all
      i = 0
      patients.each do |patient|
        i += 1
        if (i % 10 == 0) || (patient.family_name == "RABBIT")
          patient.prescriptions.create!(
            drug_id: esa_drug_ids.sample,
            treatable: patient,
            dose_amount: doses.sample,
            dose_unit: "unit",
            medication_route_id: 3,
            frequency: "weekly",
            prescribed_on: start_dates.sample.days.ago,
            provider: 0,
            by: kch_doc
          )
        end
        # add some terminated
        next unless i % 15 == 0

        patient.prescriptions.create!(
          drug_id: esa_drug_ids.sample,
          treatable: patient,
          dose_amount: doses.sample,
          dose_unit: "unit",
          medication_route_id: 3,
          frequency: "weekly",
          prescribed_on: start_dates.sample.days.ago,
          provider: 0,
          by: barts_doc,
          termination: Medications::PrescriptionTermination.new(
            terminated_on: term_dates.sample.days.ago,
            by: kch_doc
          )
        )
      end
    end
  end
end
