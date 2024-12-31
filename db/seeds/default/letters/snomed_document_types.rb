require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Letter SNOMED document types" do
    # Add a default Snomed document type used whenever a letter topic has none asociated with it.
    Letters::SnomedDocumentType.create!(
      title: "Clinical letter (record artifact)",
      code: "823691000000103",
      default_type: true
    )
  end
end
