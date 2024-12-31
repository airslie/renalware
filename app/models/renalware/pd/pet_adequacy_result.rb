#
# Captures data used for PET (Peritoneal Equilibration Test) and Adequacy.
#
module Renalware
  module PD
    class PETAdequacyResult < ApplicationRecord
      extend Enumerize
      include PatientScope
      include Accountable
      include RansackAll

      belongs_to :patient, class_name: "Renalware::PD::Patient", touch: true
      scope :ordered, -> { order(created_at: :desc) }

      MAXIMUMS = {
        pet_duration: 6,
        pet_net_uf: 2000,
        dialysate_creat_plasma_ratio: 1,
        dialysate_glucose_start: 99,
        dialysate_glucose_end: 99,
        ktv_total: 10,
        ktv_dialysate: 10,
        ktv_rrf: 10,
        crcl_total: 200,
        crcl_dialysate: 200,
        crcl_rrf: 200,
        daily_uf: 9999,
        daily_urine: 9999,
        creat_value: 9999,
        dialysate_effluent_volume: 5,
        urine_urea_conc: 999,
        urine_creat_conc: 9999,
        dietry_protein_intake: 2
      }.freeze

      # This map is currently for documentation purposes but may be useful when exporting
      # National Renal Database data
      # NRD_MAP = {
      #   pet_date: 163,
      #   dialysate_creat_plasma_ratio: 164,
      #   dialysate_glucose_start: 166,
      #   dialysate_glucose_end: 167,
      #   adequacy_date: [169,171,173],
      #   ktv_total: 168,
      #   ktv_dialysate: 170,
      #   ktv_rrf: 19,
      #   crcl_total: 172,
      #   crcl_rrf: 174,
      #   daily_urine: 21,
      #   date_rff: [20,175,22,18,16],
      #   creat_value: 176,
      #   dialysate_effluent_volume: 165,
      #   date_creat_clearance: 173,
      #   date_creat_value: 177,
      #   urine_urea_conc: 15,
      #   urine_creat_conc: 17
      # }.freeze

      enumerize :pet_type, in: %i(fast full), predicate: true

      validates :pet_type, presence: true

      validates :pet_duration,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:pet_duration]
                },
                allow_nil: true
      validates :pet_net_uf,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:pet_net_uf],
                  only_integer: true
                },
                allow_nil: true
      validates :dialysate_creat_plasma_ratio,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:dialysate_creat_plasma_ratio]
                },
                allow_nil: true
      validates :dialysate_glucose_start,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:dialysate_glucose_start]
                },
                allow_nil: true
      validates :dialysate_glucose_end,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:dialysate_glucose_end]
                },
                allow_nil: true

      validates :ktv_total,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:ktv_total]
                },
                allow_nil: true
      validates :ktv_dialysate,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:ktv_dialysate]
                },
                allow_nil: true
      validates :ktv_rrf,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:ktv_rrf]
                },
                allow_nil: true
      validates :crcl_total,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:crcl_total]
                },
                allow_nil: true
      validates :crcl_dialysate,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:crcl_dialysate],
                  only_integer: true
                },
                allow_nil: true
      validates :crcl_rrf,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:crcl_rrf],
                  only_integer: true
                },
                allow_nil: true
      validates :daily_uf,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:daily_uf],
                  only_integer: true
                },
                allow_nil: true
      validates :daily_urine,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:daily_urine],
                  only_integer: true
                },
                allow_nil: true
      validates :creat_value,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:creat_value],
                  only_integer: true
                },
                allow_nil: true
      validates :dialysate_effluent_volume,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:dialysate_effluent_volume]
                },
                allow_nil: true
      validates :urine_urea_conc,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:urine_urea_conc]
                },
                allow_nil: true
      validates :urine_creat_conc,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:urine_creat_conc],
                  only_integer: true
                },
                allow_nil: true
      validates :dietry_protein_intake,
                numericality: {
                  less_than_or_equal_to: MAXIMUMS[:dietry_protein_intake]
                },
                allow_nil: true
    end
  end
end
