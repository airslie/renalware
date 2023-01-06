# frozen_string_literal: true

module Renalware
  module UKRDC
    class TransmissionLog < ApplicationRecord
      validates :sent_at, presence: true
      validates :status, presence: true
      belongs_to :patient, class_name: "Renalware::Patient"
      enum status: {
        undefined: 0,
        error: 1,
        unsent_no_change_since_last_send: 2,
        sent: 3,
        imported: 4
      }
      enum direction: { out: 0, in: 1 }
      scope :ordered, -> { order(sent_at: :asc) }
      belongs_to :batch

      def self.with_logging(patient: nil, batch: nil, **options)
        log = new(
          patient: patient,
          sent_at: Time.zone.now,
          batch: batch,
          **options
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

      def self.policy_class
        BasePolicy
      end
    end
  end
end
