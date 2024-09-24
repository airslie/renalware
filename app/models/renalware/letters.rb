# frozen_string_literal: true

module Renalware::Letters
  def self.table_name_prefix = "letter_"
  def self.cast_author(user) = user.becomes(Author)
  def self.cast_typist(user) = user.becomes(Typist)
  def self.cast_patient(patient) = patient.becomes(Renalware::Letters::Patient)
  def self.cast_primary_care_physician(gp) = gp.becomes(Letters::PrimaryCarePhysician)

  # Errors
  class MissingPdfContentError < StandardError; end

  module Delivery
  end

  module Formats
    module FHIR
      module Resources
      end
    end
  end

  module Mailshots
    def self.table_name_prefix = "letter_mailshot_"
  end
end
