# frozen_string_literal: true

module Renalware
  class BloodPressure < NestedAttribute
    attribute :systolic, Integer
    attribute :diastolic, Integer

    validates :systolic, numericality: { allow_blank: true }
    validates :diastolic, numericality: { allow_blank: true }
    validates_with Renalware::Patients::BloodPressureValidator

    def to_s
      return "" unless systolic.present? && diastolic.present?

      "#{systolic} / #{diastolic}"
    end

    def blank?
      systolic.blank? && diastolic.blank?
    end

    # Compare BPs by first comparing systolic values. If they are equal, compare by diastolic.
    # Missing values default to a large number so they will come e.g last if #min is called
    # on an array of BloodPressures.
    def <=>(other)
      dia = diastolic.presence || 10000
      sys = systolic.presence || 10000
      other_dia = other.diastolic.presence || 10000
      other_sys = other.systolic.presence || 10000

      if sys == other_sys
        dia <=> other_dia
      else
        sys <=> other_sys
      end
    end
  end
end
