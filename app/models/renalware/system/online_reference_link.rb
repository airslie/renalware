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

      validates(
        :url,
        presence: true,
        uniqueness: true,
        format: %r(\A(https?://)?([\da-z.-]+)\.([a-z.]{2,6})([/\w .-]*)*/?\z)
      )
      validates :title, presence: true, uniqueness: true
    end
  end
end
