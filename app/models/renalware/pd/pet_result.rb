# frozen_string_literal: true

require_dependency "renalware/pd"
#
# Captures data used for PET (Peritoneal Equilibration Test) and Adequacy.
#
module Renalware
  module PD
    class PETResult < ApplicationRecord
      include PatientScope
      include Accountable
      extend Enumerize
      acts_as_paranoid

      belongs_to :patient, class_name: "Renalware::PD::Patient", touch: true
      scope :ordered, -> { order(created_at: :desc) }
      before_save :derive_calculated_attributes

      def derive_calculated_attributes
        self.d_pcr = calculated_d_pcr
        self.net_uf = calculated_net_uf
      end

      def calculated_d_pcr
        return if sample_4hr_creatinine.to_f == 0.0
        return if serum_creatinine.to_f == 0.0

        (sample_4hr_creatinine / serum_creatinine).round(2)
      end

      def calculated_net_uf
        return if volume_in.to_f == 0.0
        return if volume_out.to_f == 0.0

        (volume_out - volume_in).round(2)
      end

      enumerize :test_type, in: %i(fast full), predicate: true
      validates :performed_on, presence: true
      validates :test_type, presence: true

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
    end
  end
end
