FactoryBot.define do
  factory :pd_pet_result, class: "Renalware::PD::PETResult" do
    accountable
    performed_on { I18n.l(Time.zone.today) }
    test_type { :full }
  end
end
