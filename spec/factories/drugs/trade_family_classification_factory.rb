FactoryBot.define do
  factory :drug_trade_family_classification, class: "Renalware::Drugs::TradeFamilyClassification" do
    drug
    trade_family factory: :drug_trade_family
  end
end
