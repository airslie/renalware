require "active_support/concern"

module Renalware
  # A concern providing various *_urn methods to help build unique resource identifiers
  # for use e.g. in NHS ITK3+MESHAPI messages.
  module UniformResourceNaming
    extend ActiveSupport::Concern

    def uuid_urn(uuid)
      uuid.presence && "urn:uuid:#{uuid}"
    end

    # Examples:
    #   Urn of practice P123:
    #    "urn:nhs-uk:addressing:ods:P123"
    #   Urn of a GP with a GMC code of G456 at practice P123
    #    "urn:nhs-uk:addressing:ods:P123:G456"
    def ods_urn(practice_code:, gmc_number: nil)
      raise ArgumentError if practice_code.blank?

      codes = [practice_code, gmc_number].compact_blank.join(":")
      "urn:nhs-uk:addressing:ods:#{codes}"
    end

    # Generates a urn for a particular database record at particular hospital.
    # Examples:
    #   For a prescriptions with id 123 at MSE (RAJ):
    #     "urn:renalware:RAJ:medication_prescriptions:123"
    #
    def renalware_urn(model:)
      return if model.nil? || model.id.nil?

      hospital_ods_code = Renalware.config.ukrdc_site_code&.downcase.presence || "unk"
      "urn:renalware:#{hospital_ods_code}:#{model.class.table_name.singularize}:#{model.id}"
    end
  end
end
