require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding AKCC dialysis plans" do
    {
      pd: "PD",
      capd_la: "CAPD LA",
      capd_ga: "CAPD GA",
      capd_ga_avf: "CAPD GA + AVF",
      capd_ga_hernia: "CAPD GA + Hernia Repair",
      capd_la_avf: "CAPD LA + AVF",
      capd_la_sedation: "CAPD LA with sedation",
      capd_not_yet_assessed: "CAPD not yet assessed by CAPD Team",
      hd: "HD",
      hd_via_avf: "HD via AVF",
      hd_via_ptfe_graft: "HD via PTFE Graft",
      hd_via_line: "HD via line",
      pre_emptive_lrd: "Pre-emptive LRD",
      pre_emptive_lrd_backup_hd: "Pre-emptive LRD - backup HD",
      pre_emptive_lrd_backup_pd: "Pre-emptive LRD - backup PD",
      not_for_dial_patient_choice: "Supportive care - patient choice",
      not_for_dial_consensus: "Supportive Care - consensus",
      refuse_to_plan_for_dial: "Refusing to plan for RTT--In Denial",
      home_hd: "Home HD",
      self_care_hd: "Self Care HD",
      no_current_plan: "No Current Plan"
    }.each do |code, name|
      LowClearance::DialysisPlan.transaction do
        LowClearance::DialysisPlan.find_or_create_by!(code: code, name: name)
      end
    end
  end
end
