# This Closed (state) Session adds validation to the standard HD::Session in order
# to enforce the presence of most fields.
module Renalware
  module HD
    class Session::Closed < Session
      include Document::Base

      validates :signed_off_by, presence: true
      validates :stopped_at, presence: true
      validates :signed_off_at, presence: true
      validates :dialysate, presence: true
      validates :patient_group_directions,
                presence: true,
                if: -> { Renalware.config.hd_session_require_patient_group_directions }

      def self.policy_class = ClosedSessionPolicy

      def immutable?
        return true unless persisted?

        temporary_editing_window_has_elapsed?
      end

      class SessionDocument < ::Renalware::HD::SessionDocument
        class Info < Renalware::HD::SessionDocument::Info
          # rubocop:disable Rails/Validation
          validates_presence_of(
            attribute_set.map(&:name).reject { |att| att.name == "needle_size" }
          )
          # rubocop:enable Rails/Validation
        end
        attribute :info, Info

        class AvfAvgAssessment < Renalware::HD::SessionDocument::AvfAvgAssessment
          validates :score, presence: true
        end
        attribute :avf_avg_assessment, AvfAvgAssessment

        class Observations < Renalware::HD::SessionDocument::Observations
          validates :pulse, presence: true
          validates :blood_pressure, presence: true
          validates :weight_measured, presence: true
          validates :temperature_measured, presence: true
          validates :respiratory_rate_measured, presence: true
          validates :respiratory_rate, presence: { if: -> { respiratory_rate_measured&.yes? } }
          validates :weight, presence: { if: -> { weight_measured&.yes? } }
          validates :temperature, presence: { if: -> { temperature_measured&.yes? } }
          validates :blood_pressure, "renalware/patients/blood_pressure_presence" => true
        end
        attribute :observations_before, Observations
        attribute :observations_after, Observations

        class Dialysis < Renalware::HD::SessionDocument::Dialysis
          validates :arterial_pressure, presence: true
          validates :venous_pressure, presence: true
          validates :fluid_removed, presence: true
          validates :blood_flow, presence: true
          validates :flow_rate, presence: true
          validates :litres_processed, presence: true
        end
        attribute :dialysis, Dialysis

        class Complications < Renalware::HD::SessionDocument::Complications
          validates :line_exit_site_status, presence: true
        end
        attribute :complications, Complications

        validates :hdf, "renalware/patients/hdf_presence" => true, if: :hd_type_is_hdf?

        def hd_type_is_hdf?
          %w(hdf_pre hdf_post).include?(info.hd_type.to_s)
        end
      end

      has_document class_name: "::Renalware::HD::Session::Closed::SessionDocument"

      private

      def temporary_editing_window_has_elapsed?
        delay = Renalware.config.delay_after_which_a_finished_session_becomes_immutable
        (Time.zone.now - delay) > signed_off_at
      end
    end
  end
end
