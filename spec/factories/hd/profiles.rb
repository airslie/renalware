FactoryBot.define do
  factory :hd_profile, class: "Renalware::HD::Profile" do
    accountable
    patient
    active { true }
    hospital_unit
    dialysate factory: %i(hd_dialysate)
    scheduled_time { "11:00" }
    prescriber { accountable_actor }

    document {
      {
        dialysis: {
          hd_type: :hd
        }
      }
    }

    trait :hd do
      # noop
    end

    trait :hdf_pre do
      document {
        {
          dialysis: {
            hd_type: :hdf_pre
          }
        }
      }
    end

    trait :hdf_post do
      document {
        {
          dialysis: {
            hd_type: :hdf_post
          }
        }
      }
    end
  end
end
