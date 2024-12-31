require_relative "../../../seeds_helper"

module Renalware
  Rails.benchmark "Adding RaDaR cohorts and diagnoses" do
    file_path = File.join(File.dirname(__FILE__), "diagnoses.csv")
    CSV.foreach(file_path, headers: true).each do |row|
      Problems::RaDaR::Cohort
        .find_or_create_by(name: row["cohort"])
        .diagnoses.upsert({ name: row["diagnosis"] }, unique_by: [:cohort_id, :name])
    end
  end
end
