FactoryBot.define do
  factory :hd_prescription_administration, class: "Renalware::HD::PrescriptionAdministration" do
    accountable
    prescription
    administered_by factory: :user
    skip_administrator_validation { true }
    witnessed_by factory: :user
    skip_witness_validation { true }
    administered { true }
    notes { "some notes" }
    deleted_at { nil }
    recorded_on { Time.zone.today }
  end
end
