module Renalware
  Rails.benchmark "Adding PD PET test results" do
    creator = User.last
    file_path = File.join(File.dirname(__FILE__), "pet_results.csv")

    CSV.foreach(file_path, headers: true) do |row|
      PD::PETResult.create!(
        patient_id: row["patient_id"],
        performed_on: row["days_ago"].to_i.days.ago,
        test_type: row["test_type"],
        volume_in: row["volume_in"],
        volume_out: row["volume_out"],
        dextrose_concentration: PD::PETDextroseConcentration.find_by(value: row["dextrose"].to_f),
        infusion_time: row["infusion_time"],
        drain_time: row["drain_time"],
        overnight_volume_in: row["overnight_volume_in"],
        overnight_volume_out: row["overnight_volume_out"],
        overnight_dextrose_concentration:
          PD::PETDextroseConcentration.find_by(value: row["overnight_dextrose"].to_f),
        overnight_dwell_time: row["overnight_dwell_time"],
        sample_0hr_time: row["sample_0hr_time"],
        sample_0hr_urea: row["sample_0hr_urea"],
        sample_0hr_creatinine: row["sample_0hr_creatinine"],
        sample_0hr_glc: row["sample_0hr_glc"],
        sample_0hr_sodium: row["sample_0hr_sodium"],
        sample_0hr_protein: row["sample_0hr_protein"],
        sample_2hr_time: row["sample_2hr_time"],
        sample_2hr_urea: row["sample_2hr_urea"],
        sample_2hr_creatinine: row["sample_2hr_creatinine"],
        sample_2hr_glc: row["sample_2hr_glc"],
        sample_2hr_sodium: row["sample_2hr_sodium"],
        sample_2hr_protein: row["sample_2hr_protein"],
        sample_4hr_time: row["sample_4hr_time"],
        sample_4hr_urea: row["sample_4hr_urea"],
        sample_4hr_creatinine: row["sample_4hr_creatinine"],
        sample_4hr_glc: row["sample_4hr_glc"],
        sample_4hr_sodium: row["sample_4hr_sodium"],
        sample_4hr_protein: row["sample_4hr_protein"],
        serum_time: row["serum_time"],
        serum_urea: row["serum_urea"],
        serum_creatinine: row["serum_creatinine"],
        plasma_glc: row["plasma_glc"],
        serum_ab: row["serum_ab"],
        serum_na: row["serum_na"],
        by: creator
      )
    end
  end
end
