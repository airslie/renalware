# frozen_string_literal: true

require "month_period"

# This job when executed will store a snapshot of last month's HD session statistics
# for each HD patient.
module Renalware
  module HD
    # TODO: not sure this needs to be a job - doesn't seem to be used as such
    # instead is invoked directly
    class GenerateMonthlyStatistics < ApplicationJob
      queue_as :hd_patient_statistics
      queue_with_priority 1
      attr_reader :period

      def initialize(month: nil, year: nil)
        validate_args(month: month, year: year)

        @period = MonthPeriod.new(
          month: (month || default_month).to_i,
          year: (year || default_year).to_i
        )
        super
      end

      # :reek:UtilityFunction
      def call
        patients_with_a_closed_hd_session_in_period.each do |patient|
          GenerateMonthlyStatisticsForPatientJob.perform_later(
            patient: patient,
            month: period.month,
            year: period.year
          )
        end

        Rails.logger.info(
          "Enqueued GenerateMonthlyStatisticsForPatientJob jobs for " \
          "#{patients_with_a_closed_hd_session_in_period.length} patients"
        )
      end

      private

      def validate_args(month:, year:)
        if (month.present? && year.blank?) || (month.blank? && year.present?)
          raise(ArgumentError, "Must supply both month and year if supplying one or the other")
        end
      end

      def patients_with_a_closed_hd_session_in_period
        @patients_with_a_closed_hd_session_in_period ||=
          Sessions::AuditablePatientsInPeriodQuery.new(period: period).call
      end

      def default_month
        date_falling_in_the_previous_month.month
      end

      def default_year
        date_falling_in_the_previous_month.year
      end

      def date_falling_in_the_previous_month
        @date_falling_in_the_previous_month ||= Time.zone.today - 1.month
      end
    end
  end
end
