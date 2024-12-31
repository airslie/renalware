module Renalware
  Rails.benchmark "Adding Attachment Types" do
    file_path = File.join(File.dirname(__FILE__), "attachment_types.csv")

    Patients::AttachmentType.transaction do
      CSV.foreach(file_path, headers: true) do |row|
        Patients::AttachmentType.find_or_create_by!(name: row["name"]) do |att_type|
          att_type.description = row["description"]
          att_type.store_file_externally = row["store_file_externally"]
        end
      end
    end
  end
end
