module Renalware
  module Renal
    class ProfileDocument < Document::Embedded
      class Comorbidities < Document::Embedded
        SMOMED_MAP = {
          diabetes: 73211009,
          ischaemic_heart_dis: 414545008,
          cabg_or_angioplasty: 232717009,
          heart_failure: 84114007,
          atrial_fibrill: 49436004,
          malignancy: 86049000,
          cerebrovascular_dis: 62914000,
          chronic_obstr_pulm_dis: 13645005,
          liver_disease: 235856003,
          periph_vascular_dis: 400047006,
          amputation_for_pvd: 81723002,
          claudication: 275520000,
          ischaemic_neuropathic_ulcers: 13954005,
          non_coronary_intervention: 418285008,
          dementia: 52448006
        }.freeze

        attribute :diabetes, YearDatedConfirmation
        attribute :ischaemic_heart_dis, YearDatedConfirmation
        attribute :cabg_or_angioplasty, YearDatedConfirmation
        attribute :heart_failure, YearDatedConfirmation
        attribute :atrial_fibrill, YearDatedConfirmation
        attribute :malignancy, YearDatedConfirmation
        attribute :cerebrovascular_dis, YearDatedConfirmation
        attribute :chronic_obstr_pulm_dis, YearDatedConfirmation
        attribute :liver_disease, YearDatedConfirmation
        attribute :periph_vascular_dis, YearDatedConfirmation
        attribute :amputation_for_pvd, YearDatedConfirmation
        attribute :claudication, YearDatedConfirmation
        attribute :ischaemic_neuropathic_ulcers, YearDatedConfirmation
        attribute :non_coronary_intervention, YearDatedConfirmation
        attribute :dementia, YearDatedConfirmation
        attribute :smoking, SmokingStatus

        def self.snomed_code_for(att)
          SMOMED_MAP[att]
        end
      end
      attribute :comorbidities, Comorbidities
    end
  end
end
