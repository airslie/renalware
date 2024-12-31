FactoryBot.define do
  factory :hd_patient_statistics, class: "Renalware::HD::PatientStatistics" do
    patient factory: :hd_patient
    hospital_unit
    month { 1 }
    year { 2018 }
    # rolling false
    pre_mean_systolic_blood_pressure { 0 }
    pre_mean_diastolic_blood_pressure { 0 }
    post_mean_systolic_blood_pressure { 0 }
    post_mean_diastolic_blood_pressure { 0 }
    lowest_systolic_blood_pressure { 0 }
    highest_systolic_blood_pressure { 0 }
    mean_fluid_removal { 0 }
    mean_weight_loss { 0 }
    mean_machine_ktv { 0 }
    mean_blood_flow { 0 }
    mean_litres_processed { 0 }
    session_count { 0 }
    number_of_missed_sessions { 0 }
    dialysis_minutes_shortfall { 0 }
    dialysis_minutes_shortfall_percentage { 0 }
    mean_ufr { 0 }
    mean_weight_loss_as_percentage_of_body_weight { 0 }
    number_of_sessions_with_dialysis_minutes_shortfall_gt_5_pct { 0 }
  end
end
