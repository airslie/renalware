require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Default Event Types e.g. Biopsy, Swabs" do
    file_path = File.join(File.dirname(__FILE__), "event_types.csv")

    CSV.foreach(file_path, headers: true) do |row|
      category = Events::Category.find_or_create_by!(name: row["category"])
      Events::Type.find_or_create_by!(
        name: row["name"],
        event_class_name: row["event_class_name"],
        slug: row["slug"],
        category: category
      )
    end
  end
end
