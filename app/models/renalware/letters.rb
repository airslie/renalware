# frozen_string_literal: true

module Renalware::Letters
  def self.table_name_prefix = "letter_"
  def self.cast_author(user) = user.becomes(Author)
  def self.cast_typist(user) = user.becomes(Typist)
  def self.cast_patient(patient) = patient.becomes(Renalware::Letters::Patient)
  def self.cast_primary_care_physician(gp) = gp.becomes(Letters::PrimaryCarePhysician)

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

    # module Delivery
    #   module TransferOfCare
    #     def self.table_name_prefix = "letter_delivery_toc_"
    #   end
    # end
  end
end
