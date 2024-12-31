FactoryBot.define do
  factory :renal_profile, class: "Renalware::Renal::Profile" do
    prd_description
    first_seen_on { "01-01-2017" }
    comorbidities_updated_on { "01-01-2017" }

    document {
      {
        comorbidities: {
          smoking: {
            value: "non_smoker"
          },
          ischaemic_heart_dis: {
            status: "yes",
            confirmed_on_year: "2016"
          }
        }
      }
    }
  end
end
