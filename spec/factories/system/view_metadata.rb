FactoryBot.define do
  factory :view_metadata, class: "Renalware::System::ViewMetadata" do
    schema_name { "renalware" }
    view_name { "transplant_mdm_patients" }
    title { "Title" }
    slug { "all" }
    category { "mdm" }
    scope { "transplant" }
    columns { [] }
    filters {
      [
        Renalware::System::FilterDefinition.new(code: :sex, type: :list),
        Renalware::System::FilterDefinition.new(code: :age, type: :search)
      ]
    }
    position { 1 }
  end
end
