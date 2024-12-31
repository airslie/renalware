FactoryBot.define do
  factory :drug_trade_family, class: "Renalware::Drugs::TradeFamily" do
    sequence(:code) { |n| "Code#{n}" }
  end
end
