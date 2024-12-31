module Renalware
  module PD
    # Important to understand is that urine measurements related to renal calculations and
    # dialysate measurements relate to peritoneal calculations
    class AdequacyResult < ApplicationRecord
      include PatientScope
      include Accountable
      include PatientsRansackHelper
      include RansackAll

      acts_as_paranoid

      belongs_to :patient, class_name: "Renalware::PD::Patient", touch: true
      scope :ordered, -> { order(performed_on: :desc, created_at: :desc) }
      validates :performed_on, presence: true
      validates :dial_24_vol_in,
                numericality: { greater_than_or_equal_to: 1005, less_than_or_equal_to: 35000 },
                allow_nil: true
      validates :dial_24_vol_out,
                numericality: { greater_than_or_equal_to: 500, less_than_or_equal_to: 45000 },
                allow_nil: true
      validates :urine_24_vol,
                numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6000 },
                allow_nil: true
      validates :height, "renalware/patients/height" => true, numericality: true, allow_blank: true
      validates :weight, "renalware/patients/weight" => true, numericality: true, allow_blank: true

      before_save :derive_calculated_attributes
      before_save :update_completed

      private

      def derive_calculated_attributes
        derived_attrs = AdequacyCalculatedAttributes.new(
          adequacy: self,
          age: patient.age,
          sex: patient.sex
        ).to_h
        assign_attributes(derived_attrs)
      end

      # Derive the #complete attribute based on the presence of certain calculated fields.
      # We may be complete even if some calculated fields are null, provided an appropriate
      # urine-missing/dialysate-missing boolean is set. These indicate that the patient's urine
      # or dialysate samples where missing so the renal calculations (relating to urine) or the
      # peritoneal calculations (relating to dialysate) could not happen.
      # Note we allow urine_24_vol to be 0 as this indicates anuric.
      def update_completed
        self.complete =
          all_calculations_present? ||
          urine_missing_or_zero_but_peritoneal_calculation_present? ||
          dialysate_missing_but_renal_calculation_present?
      end

      def all_calculations_present?
        [
          total_creatinine_clearance,
          pertitoneal_creatinine_clearance,
          renal_creatinine_clearance,
          total_ktv,
          pertitoneal_ktv,
          renal_ktv
        ].all?(&:present?)
      end

      def urine_missing_or_zero_but_peritoneal_calculation_present?
        (urine_24_missing? || urine_24_vol&.zero?) &&
          [pertitoneal_creatinine_clearance, pertitoneal_ktv].all?(&:present?)
      end

      def dialysate_missing_but_renal_calculation_present?
        dial_24_missing? && [renal_creatinine_clearance, renal_ktv].all?(&:present?)
      end
    end
  end
end
