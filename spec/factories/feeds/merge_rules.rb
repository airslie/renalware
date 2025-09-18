FactoryBot.define do
  factory :feed_merge_rule, class: "Renalware::Feeds::MergeRule" do
    schema_name { "renalware" }
    table_name { "events" }
    action { "merge" }
  end
end
