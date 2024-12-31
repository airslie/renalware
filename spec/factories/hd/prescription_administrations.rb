FactoryBot.define do
  factory :hd_prescription_administration, class: "Renalware::HD::PrescriptionAdministration" do
    accountable
    prescription
    administered_by factory: %i(user)
    administrator_authorised { true }
    witnessed_by factory: %i(user)
    witness_authorised { true }
    administered { true }
    notes { "some notes" }
    deleted_at { nil }
    recorded_on { Time.zone.today }
  end
end
