FactoryBot.define do
  factory :pd_regime, class: "Renalware::PD::Regime" do
    patient
    start_date { "01/02/2015" }
    end_date { "01/02/2020" }
    treatment { "PD treatment" }
    exchanges_done_by { :by_patient }

    after(:build) do |regime|
      if regime.bags.empty?
        regime.bags << build(:pd_regime_bag, regime:)
      end
    end
  end

  factory :capd_regime, class: "Renalware::PD::CAPDRegime", parent: :pd_regime do
    amino_acid_volume { 40 }
    icodextrin_volume { 50 }
    add_hd { false }
    assistance_type { "none" }

    factory :capd_assisted_regime do
      treatment { "CAPD Dry Day Assisted" }
    end
  end

  factory :apd_regime, class: "Renalware::PD::APDRegime", parent: :pd_regime do
    start_date { "01/03/2015" }
    end_date { "02/04/2020" }
    treatment { "APD Wet day with additional exchange" }
    assistance_type { "connect" }
    amino_acid_volume { 43 }
    icodextrin_volume { 53 }
    add_hd { false }
    last_fill_volume { 630 }
    fill_volume { 1500 }
    tidal_indicator { false }
    tidal_percentage { nil }
    tidal_full_drain_every_three_cycles { nil }
    no_cycles_per_apd { 7 }
    apd_machine_pac { "123-4567-890" }
    therapy_time { 120 }

    trait :with_tidal do
      tidal_indicator { true }
      tidal_percentage { 70 }
      tidal_full_drain_every_three_cycles { true }
    end

    factory :apd_assisted_regime do
      treatment { "APD Dry Day Assisted" }
    end
  end
end
