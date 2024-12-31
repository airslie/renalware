FactoryBot.define do
  factory :body_composition, class: "Renalware::Clinical::BodyComposition" do
    accountable
    patient
    assessed_on { 1.week.ago }
    overhydration { "19.1" }
    volume_of_distribution { "52.1" }
    total_body_water { "23.1" }
    extracellular_water { "63.1" }
    intracellular_water { "23.1" }
    lean_tissue_index { "78.1" }
    fat_tissue_index { "32.1" }
    lean_tissue_mass { "32.1" }
    fat_tissue_mass { "42.1" }
    adipose_tissue_mass { "15.1" }
    body_cell_mass { "53.1" }
    quality_of_reading { 65.123 }
    weight { 23.1 }
    pre_post_hd { "post" }
    assessor { accountable_actor }
  end
end
