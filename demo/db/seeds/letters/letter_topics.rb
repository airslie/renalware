module Renalware
  Rails.benchmark "Adding Letter Topics" do
    CSV.foreach(File.join(File.dirname(__FILE__), "letter_descriptions.csv"),
                headers: true) do |row|
      Letters::Topic.find_or_create_by(text: row["text"])
    end

    Letters::Topic.where(text: "Transplant Clinic").update_all(section_identifiers: ["hd_section"])
  end
end
