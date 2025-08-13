FactoryBot.define do
  factory :access_procedure, class: "Renalware::Accesses::Procedure" do
    accountable
    type { association :access_type }
    side { :right }
    performed_on { Time.zone.today }
    performed_by { association :user }
  end
end
