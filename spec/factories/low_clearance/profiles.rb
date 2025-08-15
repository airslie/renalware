FactoryBot.define do
  factory :low_clearance_profile, class: "Renalware::LowClearance::Profile" do
    accountable
    patient { association(:low_clearance_patient, by: accountable_actor) }

    transient do
      dialysis_plan factory: :low_clearance_dialysis_plan
    end

    trait :with_document do
      document do
        {
          first_seen_on: Date.current,
          dialysis_plan: dialysis_plan.code,
          dialysis_planned_on: Date.current,
          predicted_esrf_date: Date.current,
          referral_creatinine: 10,
          referred_by: "Someone",
          referral_egfr: 1.0,
          attended_on: Date.current,
          dvd1_provided: :yes,
          dvd2_provided: :no,
          transplant_referral: :yes,
          transplant_referred_on: Date.current,
          home_hd_possible: :yes,
          self_care_possible: :no,
          access_notes: "Some notes"
        }
      end
    end
  end
end
