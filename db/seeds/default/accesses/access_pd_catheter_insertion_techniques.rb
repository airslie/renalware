require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Access Catheter Insertion Techniques" do
    file_path = File.join(File.dirname(__FILE__), "access_pd_catheter_insertion_techniques.csv")

    CSV.foreach(file_path, headers: true) do |row|
      Accesses::CatheterInsertionTechnique.find_or_create_by!(code: row["code"]) do |type|
        type.description = row["description"]
      end
    end
  end
end
