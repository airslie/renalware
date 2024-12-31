module Renalware
  module HD
    NullSessionDocument = Naught.build do |config|
      config.black_hole
      config.define_explicit_conversions
      config.singleton
    end

    class SessionDocument < Document::Embedded
      class Info < Document::Embedded
        attribute :hd_type, Document::Enum, enums: %i(hd hdf_pre hdf_post)
        attribute :access_confirmed, Boolean
        attribute :access_type
        attribute :access_type_abbreviation
        attribute :access_side, Document::Enum, enums: %i(left right)
        attribute :is_access_first_use, Document::Enum, enums: %i(yes no), default: :no
        attribute :fistula_plus_line, Document::Enum, enums: %i(yes no), default: :no
        attribute :single_needle, Document::Enum, enums: %i(yes no), default: :no
        attribute :lines_reversed, Document::Enum, enums: %i(yes no), default: :no
        attribute :machine_no
        attribute :cannulation_type
        attribute :needle_size
      end
      attribute :info, Info

      class Observations < Document::Embedded
        attribute :weight, Float
        attribute :weight_measured, Document::Enum, enums: %i(yes no), default: :yes
        attribute :pulse, Integer
        attribute :blood_pressure, BloodPressure
        attribute :temperature, Float
        attribute :temperature_measured, Document::Enum, enums: %i(yes no), default: :yes
        attribute :bm_stix, Float
        attribute :respiratory_rate, Integer
        attribute :respiratory_rate_measured, Document::Enum, enums: %i(yes no), default: :yes

        %i(
          weight
          temperature
          bm_stix
          respiratory_rate
          pulse
        ).each { |att| validates(att, numericality: { allow_blank: true }) }

        validates :weight, "renalware/patients/weight" => true
        validates :temperature, "renalware/patients/temperature" => true
        validates :bm_stix, "renalware/patients/bm_stix" => true
        validates :pulse, "renalware/patients/pulse" => true
        validates :respiratory_rate, "renalware/patients/respiratory_rate" => true
      end
      attribute :observations_before, Observations
      attribute :observations_after, Observations
      validate :pre_post_weight_difference

      class Dialysis < Document::Embedded
        attribute :arterial_pressure, Integer
        attribute :venous_pressure, Integer
        attribute :fluid_removed, Float
        attribute :blood_flow, Integer # aka pump speed
        attribute :flow_rate, Integer
        attribute :machine_urr, Integer
        attribute :machine_ktv, Float
        attribute :litres_processed, Float
        attribute :washback_quality, Document::Enum # See i18n for options

        def self.flow_rates
          (100..800).step(100)
        end

        %i(
          arterial_pressure
          venous_pressure
          fluid_removed
          flow_rate
          machine_urr
          machine_ktv
          litres_processed
        ).each { |att| validates(att, numericality: { allow_blank: true }) }

        validates :machine_urr, inclusion: { in: 0..100, allow_blank: true }
        validates :machine_ktv, inclusion: { in: (0.05..3.5), allow_blank: true }
        validates :blood_flow, numericality: {
          greater_than_or_equal_to: 50,
          less_than_or_equal_to: 800,
          allow_blank: true
        }
      end
      attribute :dialysis, Dialysis

      class HDF < Document::Embedded
        attribute :subs_fluid_pct, Integer
        attribute :subs_goal, Float
        attribute :subs_rate, Float
        attribute :subs_volume, Float

        %i(
          subs_fluid_pct
          subs_goal
          subs_rate
          subs_volume
        ).each { |att| validates(att, numericality: { allow_blank: true }) }
      end
      attribute :hdf, HDF

      class Complications < Document::Embedded
        attribute :access_site_status, Document::Enum
        attribute :line_exit_site_status, Document::Enum
        attribute :was_dressing_changed, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_mrsa_swab, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_mssa_swab, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_intradialytic_hypotension, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_saline_administration, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_cramps, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_headache, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_chest_pain, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_alteplase_urokinase, Document::Enum, enums: %i(yes no), default: :no
        attribute :had_blood_transfusion, Document::Enum, enums: %i(yes no), default: :no
        attribute :circuit_loss, Document::Enum, enums: %i(yes no), default: :no
        attribute :blown_fistula_venous, Document::Enum, enums: %i(yes no), default: :no
        attribute :blown_fistula_arterial, Document::Enum, enums: %i(yes no), default: :no
        attribute :multiple_cannulation_attempts, Document::Enum, enums: %i(yes no), default: :no
        attribute :prolonged_bleeding, Document::Enum, enums: %i(yes no), default: :no
      end
      attribute :complications, Complications

      class AvfAvgAssessment < Document::Embedded
        # See i18n for enum values
        attribute :score, Document::Enum
        attribute :aneurysm, Document::Enum, default: :N
        attribute :bruit, Document::Enum, default: :N
        attribute :thrill, Document::Enum, default: :N
        attribute :feel, Document::Enum, default: :S
        attribute :safe_to_use, Document::Enum, default: :Y
      end

      attribute :avf_avg_assessment, AvfAvgAssessment

      def error_messages
        [
          observations_before.errors.full_messages,
          observations_after.errors.full_messages,
          dialysis.errors.full_messages,
          info.errors.full_messages,
          complications.errors.full_messages,
          hdf.errors.full_messages
        ].flatten.compact
      end

      # Validate that there is not more than 7kg difference in pre and post weights.
      def pre_post_weight_difference
        pre_weight = observations_before.weight
        post_weight = observations_after.weight
        return unless pre_weight.present? && post_weight.present?

        weight_diff = (post_weight.to_f - pre_weight.to_f).round(1).abs

        if weight_diff > 7
          # "More than 7kg difference in pre/post weights"
          observations_after.errors.add(:weight, :more_than_7kg_between_pre_post_weights)
          # This validation used to be in Session::Closed::Document where it worked ok - when
          # doing a Save & Sign Off, the validation would trigger and prevent a save.
          # However after moving the validation to this base SessionDocument, so that it should
          # validate even the user just does a Save (not a sign off ie closing the session), the
          # validation does fire but the fact that observations_after has an error added does not
          # equate to document.valid? false. So to get around this I am adding an error to the
          # session document itself to indicate that observations_after is invalid. This causes
          # valid? to be false and the error in observations_after will be displayed OK.
          # TODO: get to the bottom of this at some point.
          errors.add(:observations_after, "invalid")
        end
      end
    end
  end
end
