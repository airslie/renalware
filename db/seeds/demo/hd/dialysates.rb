module Renalware
  Rails.benchmark "Adding HD Dialysates" do
    file_path = File.join(File.dirname(__FILE__), "dialysates.csv")

    CSV.foreach(file_path, headers: true) do |row|
      HD::Dialysate.find_or_create_by!(name: row["name"]) do |dialysate|
        dialysate.sodium_content = row["sodium_content"]
        dialysate.sodium_content_uom = row["sodium_content_uom"]
        dialysate.description = row["description"]
      end
    end
  end
end
