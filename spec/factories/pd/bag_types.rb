FactoryBot.define do
  factory :bag_type, class: "Renalware::PD::BagType" do
    manufacturer { "BagManufacturer" }
    description { "BagDescription" }
    glucose_content { 2.8 }
    glucose_strength { :medium }
    amino_acid { true }
    icodextrin { false }
    low_glucose_degradation { true }
    low_sodium { false }
    sodium_content { 20 }
    lactate_content { 25 }
    bicarbonate_content { 47 }
    calcium_content { 1.56 }
    magnesium_content { 2.67 }
  end
end
