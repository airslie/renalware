FactoryBot.define do
  factory :prd_description, class: "Renalware::Renal::PRDDescription" do
    initialize_with {
      Renalware::Renal::PRDDescription.find_or_create_by!(code: code) do |prd|
        prd.term = term
      end
    }
    code { "1074" }
    term { "Denys-Drash syndrome" }
  end
end
