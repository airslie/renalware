# frozen_string_literal: true

module Renalware
  log "Adding HD Dialysers" do
    file_path = File.join(File.dirname(__FILE__), "dialysers.csv")

    CSV.foreach(file_path, headers: true) do |row|
      HD::Dialyser.find_or_create_by!(group: row["group"], name: row["name"])
    end
  end
end
