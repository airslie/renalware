FactoryBot.define do
  factory :event, class: "Renalware::Events::Event" do
    accountable
    patient
    event_type factory: :access_clinic_event_type
    date_time { Time.zone.now }
    description { "Needs blood sample taken." }
    notes { "Would like son to accompany them on clinic visit." }

    factory :simple_event, class: "Renalware::Events::Simple"

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

      factory :clinical_frailty_score, class: "Renalware::Events::ClinicalFrailtyScore" do
        event_type factory: :clinical_frailty_score_event_type
        document {
          {
            score: 1
          }
        }
      end

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
  end
end
