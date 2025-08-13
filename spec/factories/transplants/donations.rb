FactoryBot.define do
  factory :transplant_donation, class: "Renalware::Transplants::Donation" do
    patient factory: :transplant_patient

    state { :volunteered }
    relationship_with_recipient { :sibling }
  end
end
