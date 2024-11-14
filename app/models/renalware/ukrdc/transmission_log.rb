# frozen_string_literal: true

module Renalware
  module UKRDC
    class TransmissionLog < ApplicationRecord
      include RansackAll

      validates :status, presence: true
      belongs_to :patient, class_name: "Renalware::Patient"
      enum :status, {
        undefined: 0,
        error: 1,
        skippped_no_change_since_last_send: 2,
        queued: 3,
        imported: 4,
        sftped: 99
      }
      enum :direction, { out: 0, in: 1 }
      scope :ordered, -> { order(created_at: :asc) }
      belongs_to :batch

      def self.with_logging(patient: nil, batch: nil, **)
        log = new(
          patient: patient,
          created_at: Time.zone.now,
          batch: batch,
          **
        )
        yield log if block_given?
        log.save!
      rescue StandardError => e
        log.error << formatted_exception(e)
        log.status = :error
        log.save!
        raise e
      end

      def self.formatted_exception(error)
        [
          "#{error.backtrace.first}: #{error.message} (#{error.class})",
          error.backtrace.drop(1).map { |line| "\t#{line}" }
        ].join("\n")
      end

      def self.policy_class = BasePolicy
    end
  end
end
