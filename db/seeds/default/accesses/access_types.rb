require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Access Types" do
    file_path = File.join(File.dirname(__FILE__), "access_types.csv")

    CSV.foreach(file_path, headers: true) do |row|
      if row["rr02_code"].present?
        rr02_code = row["rr02_code"]
        abbreviation = rr02_code
      end

      if row["rr41_code"].present?
        rr41_code = row["rr41_code"]
        abbreviation = "#{rr02_code} #{rr41_code}"
      end

      Accesses::Type.find_or_create_by!(name: row["name"]) do |type|
        type.rr02_code = rr02_code
        type.rr41_code = rr41_code
        type.abbreviation = abbreviation
      end
    end
  end
end
