FactoryGirl.define do
  sequence :rr_code do |n|
    200 + n
  end

  factory :modality_reason do
    rr_code
    description 'Patient / partner choice'
  end

  factory :pd_to_haemodialysis, parent: :modality_reason do
    type 'PdToHaemodialysis'
    description 'Effective after temporary HD'
  end

  factory :haemodialysis_to_pd, parent: :modality_reason do
    type 'HaemodialysisToPd'
    description 'Abdominal surgery or complications'
  end
end
