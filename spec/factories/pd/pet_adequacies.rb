FactoryBot.define do
  factory :pet_adequacy_result, class: "Renalware::PD::PETAdequacyResult" do
    patient
    pet_date { I18n.l(Time.zone.today) }
    pet_type { Renalware::PD::PETAdequacyResult.pet_type.values.first }
    pet_duration { Renalware::PD::PETAdequacyResult::MAXIMUMS[:pet_duration] }
    pet_net_uf { Renalware::PD::PETAdequacyResult::MAXIMUMS[:pet_net_uf] }
    adequacy_date { I18n.l(Time.zone.today) }
    dialysate_creat_plasma_ratio do
      Renalware::PD::PETAdequacyResult::MAXIMUMS[:dialysate_creat_plasma_ratio]
    end
    dialysate_glucose_start { Renalware::PD::PETAdequacyResult::MAXIMUMS[:dialysate_glucose_start] }
    dialysate_glucose_end { Renalware::PD::PETAdequacyResult::MAXIMUMS[:dialysate_glucose_end] }
    ktv_total { Renalware::PD::PETAdequacyResult::MAXIMUMS[:ktv_total] }
    ktv_dialysate { Renalware::PD::PETAdequacyResult::MAXIMUMS[:ktv_dialysate] }
    ktv_rrf { Renalware::PD::PETAdequacyResult::MAXIMUMS[:ktv_rrf] }
    crcl_total { Renalware::PD::PETAdequacyResult::MAXIMUMS[:crcl_total] }
    crcl_dialysate { Renalware::PD::PETAdequacyResult::MAXIMUMS[:crcl_dialysate] }
    crcl_rrf { Renalware::PD::PETAdequacyResult::MAXIMUMS[:crcl_rrf] }
    daily_uf { Renalware::PD::PETAdequacyResult::MAXIMUMS[:daily_uf] }
    daily_urine { Renalware::PD::PETAdequacyResult::MAXIMUMS[:daily_urine] }
    creat_value { Renalware::PD::PETAdequacyResult::MAXIMUMS[:creat_value] }
    dialysate_effluent_volume do
      Renalware::PD::PETAdequacyResult::MAXIMUMS[:dialysate_effluent_volume]
    end
    urine_urea_conc { Renalware::PD::PETAdequacyResult::MAXIMUMS[:urine_urea_conc] }
    urine_creat_conc { Renalware::PD::PETAdequacyResult::MAXIMUMS[:urine_creat_conc] }
    date_rff { Renalware::PD::PETAdequacyResult::MAXIMUMS[:date_rff] }
    date_creat_clearance { Renalware::PD::PETAdequacyResult::MAXIMUMS[:date_creat_clearance] }
    date_creat_value { Renalware::PD::PETAdequacyResult::MAXIMUMS[:date_creat_value] }
  end

  trait :maxiumums do
    pet_duration { Renalware::PD::PETAdequacyResult::MAXIMUMS[:pet_duration] }
  end
end
