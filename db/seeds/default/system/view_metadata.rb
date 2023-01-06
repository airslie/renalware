# frozen_string_literal: true

module Renalware
  log "Adding View Metadata" do
    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "transplant_mdm_patients",
      scope: "transplants",
      category: "mdm",
      schema_name: "renalware"
    ) do |view|
      view.slug = "all"
      view.title = "All"
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
      view.title = "All"
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
      view.title = "All"
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
      view.title = "All"
      view.position = 1
      view.filters = [{ code: :on_worryboard, type: :list }]
      view.columns = [].to_json
    end

    Renalware::System::ViewMetadata.find_or_create_by!(
      view_name: "akcc_mdm_patients",
      scope: "akcc",
      category: "mdm",
      slug: "all",
      schema_name: "renalware"
    ) do |view|
      view.title = "All"
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
      schema_name: "renalware"
    ) do |view|
      view.title = "All"
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
  end
end
