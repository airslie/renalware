module Renalware
  Rails.benchmark "Adding Letterheads" do
    file_path = File.join(File.dirname(__FILE__), "letterheads.csv")

    CSV.foreach(file_path, headers: true) do |row|
      name = "(#{row['site_code']}) #{row['unit_info']}"
      letterhead = Letters::Letterhead.find_or_initialize_by(name: name)
      letterhead.site_code = row["site_code"]
      letterhead.unit_info = row["unit_info"]
      letterhead.trust_name = row["trust_name"]
      letterhead.trust_caption = row["trust_caption"]
      letterhead.site_info = row["site_info"]
      letterhead.include_pathology_in_letter_body =
        (row["include_pathology_in_letter_body"] == "true")
      letterhead.save!
    end
  end
end
