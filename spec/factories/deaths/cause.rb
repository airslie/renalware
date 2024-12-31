FactoryBot.define do
  factory :cause_of_death, class: "Renalware::Deaths::Cause" do
    initialize_with {
      Renalware::Deaths::Cause.find_or_create_by!(code: code) do |cause|
        cause.description = description
      end
    }
    code { "12" }
    description { "Hyperkalaemia" }
  end
end
