require_dependency "renalware/hd"
require_dependency "renalware/patients/hdf_presence_validator"
require "document/base"

# This Closed (state) Session adds validation to the standard HD::Session in order
# to enforce the presence of most fields.
module Renalware
  module HD
    class Session::Closed < Session
      include Document::Base

      validates :start_time, presence: true
      validates :signed_off_by, presence: true
      validates :end_time, presence: true
      validates :signed_off_at, presence: true
      validates :dialysate, presence: true

      def self.policy_class
        ClosedSessionPolicy
      end

      def immutable?
        return true unless persisted?
        temporary_editing_window_has_elapsed?
      end

      class SessionDocument < ::Renalware::HD::SessionDocument
        class Info < Renalware::HD::SessionDocument::Info
          # rubocop:disable Rails/Validation
          validates_presence_of attribute_set.map(&:name)
          # rubocop:enable Rails/Validation
        end
        attribute :info, Info

        class Observations < Renalware::HD::SessionDocument::Observations
          validates :pulse, presence: true
          validates :blood_pressure, presence: true
          validates :weight_measured, presence: true
          validates :temperature_measured, presence: true
          validates :weight, presence: { if: ->{ weight_measured&.yes? } }
          validates :temperature, presence: { if: ->{ temperature_measured&.yes? } }
          validates :blood_pressure, "renalware/patients/blood_pressure_presence" => true
        end
        attribute :observations_before, Observations
        attribute :observations_after, Observations

        class Dialysis < Renalware::HD::SessionDocument::Dialysis
          # rubocop:disable Rails/Validation
          validates_presence_of attribute_set.map(&:name).reject{ |att| att == :machine_ktv }
          # rubocop:enable Rails/Validation
        end
        attribute :dialysis, Dialysis

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
