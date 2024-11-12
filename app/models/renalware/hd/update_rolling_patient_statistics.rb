# frozen_string_literal: true

module Renalware
  module HD
    class UpdateRollingPatientStatistics < ApplicationJob
      def initialize(patient:)
        @patient = patient
        super
      end

      def call
        return unless recent_sessions.any?

        stats = rolling_stats_for_this_patient
        stats.hospital_unit = most_recently_used_hospital_unit
        stats.assign_attributes(auditable_sessions.to_h)
        stats.session_count = recent_sessions.count
        stats.save!
      end

      private

      attr_reader :patient

      def recent_sessions
        @recent_sessions ||= Sessions::LatestPatientSessionsQuery.new(patient: patient).call
      end

      def auditable_sessions
        @auditable_sessions ||= Sessions::AuditableSessionCollection.new(recent_sessions)
      end

      def rolling_stats_for_this_patient
        @rolling_stats_for_this_patient ||= PatientStatistics.where(
          patient: patient,
          rolling: true,
          year: nil,
          month: nil
        ).first_or_initialize
      end

      def most_recently_used_hospital_unit
        recent_sessions.last.hospital_unit
      end
    end
  end
end
