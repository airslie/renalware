FactoryBot.define do
  factory :snomed_document_type, class: "Renalware::Letters::SnomedDocumentType" do
    title { "Clinical letter (record artifact)" }
    code { "823691000000103" }
    default_type { true }
  end
end
