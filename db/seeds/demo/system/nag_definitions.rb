module Renalware
  Rails.benchmark "Adding System Nag Definitions" do
    System::NagDefinition.create!(
      scope: :patient,
      description: "Nag if no clinical frailty score recorded in the last 1 year",
      title: "CFS",
      hint: "Please update the Clinical Frailty Score",
      sql_function_name: "patient_nag_clinical_frailty_score",
      relative_link: "patients/:id/events",
      importance: 2
    )

    System::NagDefinition.create!(
      scope: :patient,
      description: "Nag if there is an HD DNA in the last 30 days",
      title: "HD DNA",
      hint: "The patient had an HD DNA in the last 30 days",
      sql_function_name: "patient_nag_hd_dna",
      relative_link: "patients/:id/hd/dashboard",
      importance: 3
    )
  end
end
