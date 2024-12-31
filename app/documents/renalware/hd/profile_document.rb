# rubocop:disable Layout/EmptyLineBetweenDefs, Style/SingleLineMethods
# #
module Renalware
  module HD
    class ProfileDocument < Document::Embedded
      class Dialysis < Document::Embedded
        attribute :hd_type, Document::Enum, enums: %i(hd hdf_pre hdf_post)
        attribute :cannulation_type
        attribute :needle_size
        attribute :single_needle, Document::Enum, enums: %i(yes no)
        attribute :flow_rate, Integer
        attribute :blood_flow, Integer
        attribute :dialyser
        attribute :potassium, Integer
        attribute :calcium, Float
        attribute :temperature, Float
        attribute :bicarbonate, Integer, default: 32
        attribute :has_sodium_profiling, Document::Enum, enums: %i(yes no)
        attribute :sodium_first_half, Integer
        attribute :sodium_second_half, Integer
        attribute :substitution_percent, Integer

        validates_presence_of [:sodium_first_half, :sodium_second_half], if: :has_sodium_profiling?
        validates :blood_flow, numericality: {
          greater_than_or_equal_to: 50,
          less_than_or_equal_to: 800,
          allow_blank: true
        }
        validates :substitution_percent, numericality: {
          greater_than_or_equal_to: 45,
          less_than_or_equal_to: 60,
          allow_blank: true
        }, if: -> { hd_type == "hdf_pre" }
        validates :substitution_percent, numericality: {
          greater_than_or_equal_to: 20,
          less_than_or_equal_to: 30,
          allow_blank: true
        }, if: -> { hd_type == "hdf_post" }

        def self.cannulation_types; CannulationType.ordered; end
        def self.needle_sizes; [14, 15, 16, 17]; end
        def self.flow_rates; (100..800).step(100); end
        def self.dialysers; Dialyser.ordered; end
        def self.potassium_levels; [1, 2, 3, 4]; end
        def self.calcium_levels; [1.0, 1.35, 1.5]; end
        def self.temperature_levels; [35.0, 35.5, 36.0, 36.5, 37.0]; end
        def self.bicarbonate_levels; (22..43).step(1); end
        def self.sodium_levels; [136, 137, 138, 140, 145]; end

        def has_sodium_profiling?
          has_sodium_profiling&.yes?
        end
      end
      attribute :dialysis, Dialysis

      class Anticoagulant < Document::Embedded
        attribute :type, Document::Enum # See .yml file for values
        attribute :loading_dose
        attribute :hourly_dose
        attribute :stop_time
        def self.stop_times; [["0:30", 30], ["1:00", 60], ["1:30", 90], ["2:00", 120]]; end
      end
      attribute :anticoagulant, Anticoagulant

      class Drugs < Document::Embedded
        attribute :on_esa, Document::Enum, enums: %i(yes no unknown)
        attribute :on_iron, Document::Enum, enums: %i(yes no unknown)
        attribute :on_warfarin, Document::Enum, enums: %i(yes no unknown)
      end
      attribute :drugs, Drugs

      class Transport < Document::Embedded
        attribute :has_transport, Document::Enum, enums: %i(yes no unknown)
        attribute :type, Document::Enum # See .yml file for values
        attribute :decided_on, Date
      end
      attribute :transport, Transport

      class CareLevel < Document::Embedded
        attribute :level, Document::Enum # See .yml file for values
        attribute :assessed_on, Date
      end
      attribute :care_level, CareLevel
    end
  end
end
# rubocop:enable Layout/EmptyLineBetweenDefs, Style/SingleLineMethods
