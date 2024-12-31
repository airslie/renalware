module Renalware
  module Dietetics
    class ClinicVisit < Renalware::Clinics::ClinicVisit
      include ::Document::Base

      def self.policy_class = Renalware::Clinics::ClinicVisitPolicy

      def to_form_partial_path
        "renalware/dietetics/clinic_visits/form"
      end

      def to_toggled_row_partial_path
        "renalware/dietetics/clinic_visits/toggled_row"
      end

      def set_weight_change
        previous_weight = document.previous_weight
        return unless weight.present? && previous_weight.present?

        document.weight_change = ((weight - previous_weight) / previous_weight * 100).round(1)
      end
      before_save :set_weight_change

      def set_next_review_on
        return unless document.next_review_in.present?

        document.next_review_on = case document.next_review_in.to_sym
                                  when :three_months
                                    Time.zone.today + 3.months
                                  when :six_months
                                    Time.zone.today + 6.months
                                  when :twelve_months
                                    Time.zone.today + 12.months
                                  end
      end
      before_save :set_next_review_on

      class Document < ::Document::Embedded
        attribute :assessment_type, ::Document::Enum, default: :dietetic_r_v
        attribute :visit_type, ::Document::Enum
        attribute :attendance, ::Document::Enum, default: :attended
        attribute :weight_notes, String
        attribute :previous_weight, Integer
        attribute :previous_weight_date, Date
        attribute :ideal_body_weight, Integer
        attribute :adjusted_bmi, Integer
        attribute :weight_change, Float

        validates :previous_weight, :ideal_body_weight,
                  allow_blank: true,
                  numericality: {
                    only_integer: true,
                    greater_than_or_equal_to: 15,
                    less_than_or_equal_to: 300
                  }

        attribute :waist_circumference, Integer
        validates :waist_circumference,
                  allow_blank: true,
                  numericality: {
                    only_integer: true,
                    greater_than_or_equal_to: 30,
                    less_than_or_equal_to: 300
                  }

        attribute :dietary_protein_requirement, Integer
        attribute :dietary_protein_intake, Integer

        validates :dietary_protein_requirement, :dietary_protein_intake,
                  allow_blank: true,
                  numericality: {
                    only_integer: true,
                    greater_than_or_equal_to: 5,
                    less_than_or_equal_to: 250
                  }
        attribute :high_biological_value, Integer

        validates :high_biological_value,
                  allow_blank: true,
                  numericality: {
                    only_integer: true,
                    greater_than_or_equal_to: 0,
                    less_than_or_equal_to: 100
                  }

        attribute :energy_requirement, Integer
        attribute :energy_intake, Integer

        validates :energy_requirement, :energy_intake,
                  allow_blank: true,
                  numericality: {
                    only_integer: true,
                    greater_than_or_equal_to: 500,
                    less_than_or_equal_to: 4000
                  }

        attribute :dominant_hand, ::Document::Enum, default: :right
        attribute :handgrip_left, Integer
        attribute :handgrip_right, Integer

        validates :handgrip_left, :handgrip_right,
                  allow_blank: true,
                  numericality: {
                    only_integer: true,
                    greater_than_or_equal_to: 1,
                    less_than_or_equal_to: 150
                  }

        attribute :sga_assessment, ::Document::Enum,
                  enums: %i(na well_nourished moderate_malnutrition severe_malnutrition)
        attribute :plan, String
        attribute :intervention_a, ::Document::Enum
        attribute :intervention_b, ::Document::Enum
        attribute :intervention_c, ::Document::Enum

        attribute :time_for_consultation, Integer
        attribute :time_for_documentation, Integer
        attribute :next_review_in, ::Document::Enum,
                  enums: %i(one_month two_months three_months six_months twelve_months)
        attribute :next_review_on, Date
      end

      has_document
    end
  end
end
