require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding AKCC dialysis plans" do
    {
      pd: ["PD", 9],
      capd_la: ["CAPD LA", 9],
      capd_ga: ["CAPD GA", 9],
      capd_ga_avf: ["CAPD GA + AVF", 9],
      capd_ga_hernia: ["CAPD GA + Hernia Repair", 9],
      capd_la_avf: ["CAPD LA + AVF", 9],
      capd_la_sedation: ["CAPD LA with sedation", 9],
      capd_not_yet_assessed: ["CAPD not yet assessed by CAPD Team", 9],
      hd: ["HD", 7],
      hd_via_avf: ["HD via AVF", 7],
      hd_via_ptfe_graft: ["HD via PTFE Graft", 7],
      hd_via_line: ["HD via line", 7],
      pre_emptive_lrd: ["Pre-emptive LRD", 6],
      pre_emptive_lrd_backup_hd: ["Pre-emptive LRD - backup HD", 6],
      pre_emptive_lrd_backup_pd: ["Pre-emptive LRD - backup PD", 6],
      not_for_dial_patient_choice: ["Supportive care - patient choice", 10],
      not_for_dial_consensus: ["Supportive Care - consensus", 10],
      refuse_to_plan_for_dial: ["Refusing to plan for RTT--In Denial", 5],
      home_hd: ["Home HD", 8],
      self_care_hd: ["Self Care HD", 7],
      no_current_plan: ["No Current Plan", 5]
    }.each do |code, (name, rr51_code)|
      LowClearance::DialysisPlan.transaction do
        LowClearance::DialysisPlan.find_or_create_by!(code: code, name: name) do |plan|
          plan.ukrdc_assessment_outcome_code = rr51_code
        end
      end
    end
  end
end
