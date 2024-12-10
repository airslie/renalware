# frozen_string_literal: true

module Renalware
  module System
    # Represents a URL to an online reference that a patient can view to get more information
    # about their condition or treatment. We can generate a QRCode for this URL at any point
    # eg for inserting into a letter.
    # A clinician can add these records through the admin UI or while creating a letter.
    # We could enhance at some point to fetch the og:title and og:description from the head of the
    # html document that is referenced, in order to pre-populate title and description.
    class OnlineReferenceLink < ApplicationRecord
      include Accountable
      include RansackAll

      validates :url, presence: true, uniqueness: true
      validate  :url_format_correct

      def url_format_correct
        return if url.blank?

        unless url.downcase.start_with?("https://", "http://")
          errors.add(:url, :invalid)
        end
      end

      validates :title, presence: true, uniqueness: true
      validate :validate_letter_inclusion_dates
      validates :include_in_letters_from,
                presence: true,
                if: ->(rec) { rec.include_in_letters_until.present? }

      scope :default_in_new_letters, -> {
        where(include_in_letters_from: ..Time.zone.today)
          .and(where(include_in_letters_until: Time.zone.today..)
          .or(where(include_in_letters_until: nil)))
      }

      # rubocop:disable Style/SoleNestedConditional
      def validate_letter_inclusion_dates
        if include_in_letters_from.present? && include_in_letters_until.present?
          if include_in_letters_from > include_in_letters_until
            errors.add(:include_in_letters_until, "cannot be before the from date")
          end
        end
      end
      # rubocop:enable Style/SoleNestedConditional
    end
  end
end
