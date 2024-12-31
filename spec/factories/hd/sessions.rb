FactoryBot.define do
  factory :hd_session, class: "Renalware::HD::Session::Open" do
    accountable
    patient factory: %i(hd_patient)
    hospital_unit
    dialysate factory: %i(hd_dialysate)

    signed_on_by { accountable_actor }

    started_at { 4.hours.ago }
    stopped_at { 1.hour.ago }

    notes { "Some notes" }

    factory :hd_open_session

    factory :hd_dna_session, class: "Renalware::HD::Session::DNA" do
      document {
        {
          patient_on_holiday: "yes"
        }
      }
    end

    factory :hd_closed_session, class: "Renalware::HD::Session::Closed" do
      # started_at { 1.week.ago }
      # stopped_at { 1.week.ago + 3.hours }
      signed_off_at { 1.day.ago }
      signed_off_by { accountable_actor }

      after(:build) do |session|
        session.document = build(:hd_session_document).marshal_dump
      end
    end
  end
end
