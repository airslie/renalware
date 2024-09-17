# frozen_string_literal: true

require_relative "../../seeds_helper"

module Renalware
  extend SeedsHelper

  log "Adding View Metadata" do
    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "transplant_mdm_patients",
      scope: "transplants", # code namespace
      category: "mdm",
      schema_name: "renalware"
    ) do |view|
      view.slug = "all"
      view.title = "Transplant" # displayed in the menu
      view.position = 1
      view.filters = [
        { code: "sex", type: "list" },
        { code: "tx_status", type: "list" },
        { code: "on_worryboard", type: "list" },
        { code: "tx_in_past_3m", type: "list" },
        { code: "tx_in_past_12m", type: "list" },
        { code: "patient_name", type: "search" }
      ]
      view.columns = [].to_json # empty will display all
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "hd_mdm_patients",
      scope: "hd",
      category: "mdm",
      slug: "all",
      schema_name: "renalware"
    ) do |view|
      view.title = "HD"
      view.position = 1
      view.filters = [
        { code: :schedule, type: :list },
        { code: :hospital_unit, type: :list },
        { code: :named_nurse, type: :list },
        { code: :named_consultant, type: :list },
        { code: :on_worryboard, type: :list }
      ]
      # schedule: :list,
      # hospital_unit: :list,
      # named_nurse: :list,
      # on_worryboard: :list
      view.columns = [].to_json # empty will display all
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "supportive_care_mdm_patients",
      scope: "supportive_care",
      category: "mdm",
      slug: "all",
      schema_name: "renalware"
    ) do |view|
      view.title = "Supportive Care"
      view.position = 1
      view.filters = [{ code: :on_worryboard, type: :list }].to_json
      view.columns = [].to_json
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "pd_mdm_patients",
      scope: "pd",
      category: "mdm",
      slug: "all",
      schema_name: "renalware"
    ) do |view|
      view.title = "PD"
      view.position = 1
      view.filters = [
        {
          code: "on_worryboard",
          type: 0
        },
        {
          code: "hospital_centre",
          type: 0
        },
        {
          code: "named_consultant",
          type: 0
        },
        {
          code: "named_nurse",
          type: 0
        }
      ]
      view.columns = [].to_json
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "akcc_mdm_patients",
      scope: "low_clearance",
      category: "mdm",
      slug: "all",
      schema_name: "renalware"
    ) do |view|
      view.title = "AKCC" # aka low clearance
      view.position = 1
      view.filters = [
        { code: :on_worryboard, type: :list },
        { code: :tx_candidate, type: :list },
        { code: :hgb_range, type: :list },
        { code: :urea_range, type: :list }
      ]
      view.columns = [].to_json
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "dietetic_mdm_patients",
      scope: "dietetics",
      category: "mdm",
      slug: "all",
      schema_name: "renalware",
      materialized: true,
      refresh_schedule: "0 * * * *" # every hour
    ) do |view|
      view.title = "Dietetic"
      view.position = 1
      view.filters = [
        { code: :on_worryboard, type: :list },
        { code: :dietician_name, type: :list },
        { code: :hospital_centre, type: :list },
        { code: :modality_name, type: :list },
        { code: :consultant_name, type: :list },
        { code: :outstanding_dietetic_visit, type: :list }
      ]
      view.columns = [].to_json
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "reporting_unit_patients",
      scope: "patients",
      category: "report",
      description: "Number of patients in each unit each month over the last 10 years",
      slug: "unit_patients",
      schema_name: "renalware"
    ) do |view|
      view.title = "Number of patients per unit"
      view.position = 1
      view.filters = [
        { code: :hospital, type: :list },
        { code: :unit, type: :list },
        { code: :year, type: :list }
      ]
      view.columns = [].to_json
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "reporting_main_authors_audit",
      scope: "patients",
      category: "report",
      description: "A list of authors with statistics across the last 3 months of letters.",
      slug: "bone_audit",
      schema_name: "renalware"
    ) do |view|
      view.title = "Main Authors"
      view.materialized = true
      view.position = 2
      view.filters = []
      view.columns = [
        { code: "name", name: "Author" },
        { code: "total_letters", name: "Total" },
        { code: "percent_archived_within_7_days", name: "% Archived in 5 working days" },
        { code: "avg_days_to_archive", name: "Avg. days to archive" },
        { code: "user_id", name: "User ID" }
      ].to_json
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "reporting_hd_blood_pressures_audit",
      scope: "patients",
      category: "report",
      slug: "hd_blood_pressures",
      schema_name: "renalware"
    ) do |view|
      view.title = "HD Blood Pressures"
      view.position = 3
      view.materialized = true
      view.filters = []
      view.columns = [
        { code: "hospital_unit_name", name: "Unit" },
        { code: "systolic_pre_avg", name: "Sys pre avg" },
        { code: "diastolic_pre_avg", name: "Dia pre avg" },
        { code: "systolic_post_avg", name: "Sys post avg" },
        { code: "distolic_post_avg", name: "Dia post avg" }
      ].to_json
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "reporting_hd_overall_audit",
      scope: "patients",
      category: "report",
      description: "An overview of HD activity in the current month across all HD units.",
      slug: "hd_overall",
      schema_name: "renalware"
    ) do |view|
      view.title = "HD Overall"
      view.materialized = true
      view.position = 4
      view.filters = []
      view.columns = [
        { code: "name", name: "Unit" },
        { code: "year", name: "Year" },
        { code: "month", name: "Month" },
        { code: "patient_count", name: "No. patients" },
        { code: "percentage_hgb_gt_100", name: "% HGB > 100" },
        { code: "percentage_hgb_gt_130", name: "% HGB > 130" },
        { code: "percentage_phosphate_lt_1_8", name: "% Phosphate < 1.8" },
        { code: "percentage_pth_lt_300", name: "% PTH < 300" },
        { code: "percentage_urr_gt_64", name: "% URR > 64" },
        { code: "percentage_urr_gt_69", name: "% URR > 69" },
        { code: "percentage_access_fistula_or_graft", name: "% w/fistula or graft" },
        { code: "avg_missed_hd_time", name: "Avg. missed HD time" },
        { code: "pct_missed_sessions_gt_10_pct", name: "% sessions >5% dialysis time missed" },
        { code: "pct_shortfall_gt_5_pct", name: "% missing >10% HD sessions" }
      ].to_json
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "reporting_bone_audit",
      scope: "patients",
      category: "report",
      slug: "bone_audit",
      schema_name: "renalware"
    ) do |view|
      view.title = "Bone audit"
      view.position = 5
      view.filters = []
      view.columns = [
        { code: "modality", name: "Modality" },
        { code: "patient_count", name: "No. patients" },
        { code: "avg_cca", name: "Avg CCA" },
        { code: "pct_cca_2_1_to_2_4", name: "% CCA 2.1-2.4" },
        { code: "pct_pth_gt_300", name: "% PTH > 300" },
        { code: "pct_pth_gt_800_pct", name: "% PTH > 800" },
        { code: "avg_phos", name: "Avg PHOS" },
        { code: "max_phos", name: "Max PHOS" },
        { code: "pct_phos_lt_1_8", name: "% PHOS < 1.8" }
      ].to_json
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "reporting_anaemia_audit",
      scope: "patients",
      category: "report",
      description: "ESD/EPO audit",
      slug: "anemia_audit",
      schema_name: "renalware"
    ) do |view|
      view.title = "Anaemia"
      view.position = 6
      view.filters = []
      view.columns = [
        { code: "modality", name: "Modality" },
        { code: "patient_count", name: "Patients" },
        { code: "avg_hgb", name: "Avg HGB" },
        { code: "pct_hgb_gt_eq_10", name: "% HGB ≥ 10" },
        { code: "pct_hgb_gt_eq_11", name: "% HGB ≥ 11" },
        { code: "pct_hgb_gt_eq_13", name: "% HGB ≥ 13" },
        { code: "avg_fer", name: "Avg FER" },
        { code: "pct_fer_gt_eq_150", name: "% FER ≥ 150" },
        { code: "count_epo", name: "No on EPO" },
        { code: "count_mircer", name: "Count Mircer*" },
        { code: "count_neo", name: "Count Neo*" },
        { code: "count_ara", name: "Count Ara*" }
      ].to_json
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "reporting_pd_audit",
      scope: "patients",
      category: "report",
      slug: "pd_audit",
      schema_name: "renalware"
    ) do |view|
      view.title = "PD audit"
      view.position = 7
      view.filters = []
      view.columns = [
        { code: "pd_type", name: "PD Type" },
        { code: "patient_count", name: "No. patients" },
        { code: "avg_hgb", name: "Avg HGB" },
        { code: "pct_hgb_gt_100", name: "% HGB > 100" },
        { code: "pct_on_epo", name: "% on EPO" },
        { code: "pct_pth_gt_500", name: "% PTH > 500" },
        { code: "pct_phosphate_gt_1_8", name: "% Phosphate > 1.8" },
        { code: "pct_strong_medium_bag_gt_1l", name: "% Strong/medium bags > 1L" }
      ].to_json
    end
  end
end
