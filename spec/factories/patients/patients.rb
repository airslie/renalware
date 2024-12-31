FactoryBot.define do
  sequence :nhs_number do |n|
    %w(
      6393739592
      4414733227
      5552737601
      4696133478
      4904230000
      5477425407
      7465613493
      9827026836
      2132173117
      2717073604
      3477113764
      7114008236
      9660350961
      2637392835
      1833834704
      9707196408
      0676304567
      0558366333
      1573555126
      5543098111
    )[n]
  end

  sequence :local_patient_id do |n|
    n.to_s.rjust(6, "Z99999")
  end

  factory :patient, class: "Renalware::Patient" do
    accountable
    nhs_number
    secure_id { SecureRandom.base58(24) }
    local_patient_id
    family_name { "Jones" }
    given_name { "Jack" }
    born_on { "01/01/1988" }
    paediatric_patient_indicator { "0" }
    sex { "M" }
    died_on { nil }
    first_cause_id { nil }
    hospital_centre

    # ensures addressable_type and addressable_id work is assigned, using
    # FactoryBot's simple assoc method does not work
    #
    before(:create) do |patient|
      patient.build_current_address(attributes_for(:address))
    end

    trait :with_ethnicity do
      ethnicity factory: :ethnicity
    end
  end
end
