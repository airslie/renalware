FactoryBot.define do
  factory :access_procedure, class: "Renalware::Accesses::Procedure" do
    type { association :access_type }
    side { :right }
    performed_on { Time.zone.today }
  end
end
