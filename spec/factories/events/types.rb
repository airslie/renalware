FactoryBot.define do
  factory :event_type, class: "Renalware::Events::Type" do
    initialize_with do
      Renalware::Events::Type.find_or_create_by(
        name: name,
        category: category
      )
    end

    category factory: :event_category
    name { "Test" }

    factory :access_clinic_event_type do
      name { "Access--Clinic" }
      hidden { false }
    end

    factory :swab_event_type do
      name { "Swab" }
      event_class_name { "Renalware::Events::Swab" }
      slug { "swabs" }
      author_change_window_hours { -1 }
      admin_change_window_hours { -1 }
    end

    factory :biopsy_event_type do
      name { "Renal biopsy" }
      event_class_name { "Renalware::Events::Biopsy" }
    end

    factory :pd_line_change_event_type do
      name { "PD Line Change" }
      slug { "pd_line_changes" }
    end

    factory :investigation_event_type do
      name { "Investigation" }
      slug { "investigations" }
      event_class_name { "Renalware::Events::Investigation" }
    end

    factory :vaccination_event_type do
      name { "Vaccination" }
      slug { "vaccinations" }
      event_class_name { "Renalware::Virology::Vaccination" }
    end

    factory :remote_monitoring_registration do
      name { "Remote Monitoring Registration" }
      slug { "remote_monitoring_registration" }
      event_class_name { "Renalware::RemoteMonitoring::Registration" }
    end

    factory :advanced_care_plan_event_type do
      name { "AdvancedCarePlan" }
      slug { "advanced_care_plans" }
      event_class_name { "Renalware::Events::AdvancedCarePlan" }
    end

    factory :clinical_frailty_score_event_type do
      name { "Clinical Frailty Score" }
      slug { "clinical_frailty_score" }
      event_class_name { "Renalware::Events::ClinicalFrailtyScore" }
    end

    factory :medication_review_event_type do
      name { "Medication Review" }
      event_class_name { "Renalware::Medications::Review" }
    end

    factory :research_study_event_type do
      name { "Research Study" }
      event_class_name { "Renalware::Research::StudyEvent" }
    end

    factory :transplant_review_event_type do
      name { "Transplant Review" }
      event_class_name { "Renalware::Transplants::Review" }
    end
  end
end
