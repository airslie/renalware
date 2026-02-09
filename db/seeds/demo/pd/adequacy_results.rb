module Renalware
  Rails.benchmark "Adding PD Adequacy test results" do
    creator = User.last
    file_path = File.join(File.dirname(__FILE__), "adequacy_results.csv")

    CSV.foreach(file_path, headers: true) do |row|
      PD::AdequacyResult.create!(
        patient_id: row["patient_id"],
        performed_on: row["days_ago"].to_i.days.ago,
        serum_urea: row["serum_urea"],
        serum_creatinine: row["serum_creatinine"],
        serum_ab: row["serum_ab"],
        plasma_glc: row["plasma_glc"],
        dial_24_vol_in: row["dial_24_vol_in"],
        dial_24_vol_out: row["dial_24_vol_out"],
        dial_24_missing: row["dial_24_missing"].to_s.casecmp("yes").zero?,
        urine_24_vol: row["urine_24_vol"],
        urine_24_missing: row["urine_24_missing"].to_s.casecmp("yes").zero?,
        dialysate_urea: row["dialysate_urea"],
        dialysate_creatinine: row["dialysate_creatinine"],
        dialysate_glu: row["dialysate_glu"],
        dialysate_na: row["dialysate_na"],
        dialysate_protein: row["dialysate_protein"],
        urine_urea: row["urine_urea"],
        urine_creatinine: row["urine_creatinine"],
        urine_na: row["urine_na"],
        urine_k: row["urine_k"],
        by: creator
      )
      # Note that these attributes are calculated when we save
      # total_creatinine_clearance
      # pertitoneal_creatinine_clearance
      # renal_creatinine_clearance
      # total_ktv
      # pertitoneal_ktv
      # renal_ktv
      # dietry_protein_intake
    end
  end
end
