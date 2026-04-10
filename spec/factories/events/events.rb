FactoryBot.define do
  factory :event, class: "Renalware::Events::Event" do
    accountable
    patient
    event_type factory: :access_clinic_event_type
    date_time { Time.current }
    description { "Needs blood sample taken." }
    notes { "Would like son to accompany them on clinic visit." }

    after(:build) do |event|
      event.type ||= "Renalware::Events::AccessClinic"
    end

    factory :simple_event, class: "Renalware::Events::Simple" do
      event_type factory: :simple_event_type
    end

    factory :swab, class: "Renalware::Events::Swab" do
      event_type factory: :swab_event_type
      document {
        {
          type: Renalware::Events::Swab::Document.type.values.first,
          result: Renalware::Events::Swab::Document.result.values.first,
          location: "The location"
        }
      }
    end

    factory :investigation, class: "Renalware::Events::Investigation" do
      event_type factory: :investigation_event_type
      document {
        {
          modality: "other",
          type: Renalware::Events::Investigation::Document.type.values.first,
          result: "result"
        }
      }

      trait :transplant_recipient do
        before :create do |investigation|
          investigation.document.modality = "transplant_recipient"
        end
      end

      trait :transplant_donor do
        before :create do |investigation|
          investigation.document.modality = "transplant_donor"
        end
      end
    end

    factory :clinical_frailty_score, class: "Renalware::Events::ClinicalFrailtyScore" do
      event_type factory: :clinical_frailty_score_event_type
      document { { score: 1 } }
    end

    factory :biopsy, class: "Renalware::Events::Biopsy" do
      event_type factory: :clinical_frailty_score_event_type
      document { { result1: :acute_amr, result2: :gt_50 } }
    end

    factory :advanced_care_plan, class: "Renalware::Events::AdvancedCarePlan" do
      event_type factory: :advanced_care_plan_event_type
      document { { state: :not_required } }
    end

    factory :transplant_offer, class: "Renalware::Transplants::Offer" do
      event_type factory: :transplant_offer_event_type
      document { { donor_id: "NHSBT-12345" } }
    end
  end
end
