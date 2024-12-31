module Renalware
  Rails.benchmark "Adding Demo Event Types" do
    file_path = File.join(File.dirname(__FILE__), "types.csv")

    CSV.foreach(file_path, headers: true) do |row|
      category = Events::Category.find_or_create_by!(name: row["category"])
      Events::Type.find_or_create_by!(name: row["name"], category: category) do |event_type|
        event_type.event_class_name = row["event_class_name"]
        event_type.save_pdf_to_electronic_public_register =
          row["save_pdf_to_electronic_public_register"]
        event_type.external_document_type_code = row["external_document_type_code"]
        event_type.external_document_type_description = row["external_document_type_description"]
      end
    end
  end
end
