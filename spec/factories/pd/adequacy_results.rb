FactoryBot.define do
  factory :pd_adequacy_result, class: "Renalware::PD::AdequacyResult" do
    accountable
    performed_on { I18n.l(Time.zone.today) }
    urine_urea { 10 }
    urine_creatinine { 10 }
    urine_24_vol { 1000 }
    dialysate_urea { 10 }
    dialysate_creatinine { 10 }
    dial_24_vol_out { 1500 }
    serum_urea { 10 }
    serum_creatinine { 10 }
  end
end
