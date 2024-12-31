module Renalware
  Rails.benchmark "Adding PD Bag Types" do
    file_path = File.join(File.dirname(__FILE__), "bag_types.csv")

    CSV.foreach(file_path, headers: true) do |row|
      PD::BagType.find_or_create_by!(
        description: row["description"],
        manufacturer: row["manufacturer"],
        glucose_content: row["glucose_content"],
        glucose_strength: row["glucose_strength"],
        amino_acid: row["amino_acid"],
        icodextrin: row["icodextrin"],
        low_glucose_degradation: row["low_glucose_degradation"],
        low_sodium: row["low_sodium"],
        sodium_content: row["sodium_content"],
        lactate_content: row["lactate_content"],
        bicarbonate_content: row["bicarbonate_content"],
        calcium_content: row["calcium_content"],
        magnesium_content: row["magnesium_content"]
      )
    end
  end
end
