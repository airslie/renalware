module Renalware
  module Transplants
    class DonorWorkupDocument < Document::Embedded
      class Comorbidities < Document::Embedded
        attribute :smoking, YearDatedConfirmation
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
      end
      attribute :comorbidities, Comorbidities

      class Infections < Document::Embedded
        attribute :hiv, InfectionStatus
        attribute :hcv, InfectionStatus
        attribute :htlv_preop, InfectionStatus
        attribute :syphilis_preop, InfectionStatus
        attribute :htlv, DatedTest
        attribute :ebv, DatedTest
        attribute :syphilis, DatedTest
        attribute :toxoplasmosis, DatedTest
        attribute :cytology, DatedTest
      end
      attribute :infections, Infections

      class ImagingAndScans < Document::Embedded
        attribute :ecg_comment, DatedResult
        attribute :chest_xray, DatedResult
        attribute :renal_ultrasound, DatedResult
      end
      attribute :imaging_and_scans, ImagingAndScans

      class CreatinineClearance < Document::Embedded
        attribute :clearance_type, Document::Enum, enums: %w(cockroft_gault schwartz other)
        attribute :clearance, DatedResult
        attribute :measured_clearance, DatedResult
      end
      attribute :creatinine_clearance, CreatinineClearance

      class GlomerularFiltrationRate < Document::Embedded
        attribute :is_measured_value_corrected, Boolean
        attribute :value_corrected_for_bsa, Boolean
        attribute :measured_value, DatedResult
        attribute :isotopic_value, DatedResult
      end
      attribute :glomerular_filtration_rate, GlomerularFiltrationRate

      class UrineDipsticks < Document::Embedded
        attribute :blood, DatedResult
        attribute :protein, DatedResult
      end
      attribute :urine_dipsticks, UrineDipsticks

      class OtherInvestigations < Document::Embedded
        attribute :number_renal_arteries, Integer
        attribute :sitting_blood_pressure
        attribute :protein_creatinine_ratio, DatedResult
        attribute :egfr, DatedResult
        attribute :haemoglobinopathy, DatedResult
        attribute :oral_gtt, DatedResult
      end
      attribute :other_investigations, OtherInvestigations
    end
  end
end
