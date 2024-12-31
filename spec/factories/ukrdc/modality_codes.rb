FactoryBot.define do
  factory :ukrdc_modality_code, class: "Renalware::UKRDC::ModalityCode" do
    trait :hd do
      description { "Haemodialysis" }
      txt_code { 1 }
      qbl_code { 1 }
    end

    trait :hdf do
      description { "Haemodiafiltration" }
      txt_code { 3 }
      qbl_code { 3 }
    end

    trait :pd do
      description { "Peritoneal dialysis – type unknown" }
      txt_code { 19 }
      qbl_code { 19 }
    end

    trait :apd do
      description { "APD" }
      txt_code { 12 }
      qbl_code { 12 }
    end

    trait :apd_assisted do
      description { "Assisted APD" }
      txt_code { 121 }
      qbl_code { 121 }
    end

    trait :capd do
      description { "CAPD" }
      txt_code { 11 }
      qbl_code { 11 }
    end

    trait :capd_assisted do
      description { "Assisted CAPD" }
      txt_code { 111 }
      qbl_code { 111 }
    end

    trait :type_unknown do
      description { "Transplant ; type unknown" }
      txt_code { 29 }
      qbl_code { 29 }
    end

    trait :cadaver do
      description { "Transplant ; Cadaver donor" }
      txt_code { 20 }
      qbl_code { 20 }
    end

    trait :live_related_sibling do
      description { "Transplant ; Transplant; Live related - sibling" }
      txt_code { 21 }
      qbl_code { 21 }
    end

    trait :live_related_father do
      description { "Transplant ; Transplant; Live related - father" }
      txt_code { 74 }
      qbl_code { 74 }
    end

    trait :live_related_mother do
      description { "Transplant ; Transplant; Live related - mother" }
      txt_code { 75 }
      qbl_code { 75 }
    end

    trait :live_related_child do
      description { "Transplant ; Transplant; Live related - child" }
      txt_code { 77 }
      qbl_code { 77 }
    end

    trait :live_related_other do
      description { "Transplant ; Transplant; Live related - other" }
      txt_code { 23 }
      qbl_code { 23 }
    end

    trait :non_heart_beating do
      description { "Transplant ; non-heart-beating donor" }
      txt_code { 28 }
      qbl_code { 28 }
    end

    trait :live_unrelated do
      description { "Transplant ; Live genetically unrelated" }
      txt_code { 24 }
      qbl_code { 24 }
    end
  end
end
