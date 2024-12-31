require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Access Sites" do
    file_path = File.join(File.dirname(__FILE__), "access_sites.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Accesses::Site.find_or_create_by!(code: row["code"]) do |site|
        site.name = row["name"]
      end
    end
  end
end
