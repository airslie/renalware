FactoryBot.define do
  factory :catheter_insertion_technique, class: "Renalware::Accesses::CatheterInsertionTechnique" do
    code { 2 }
    description { "Laparoscopic" }
  end
end
