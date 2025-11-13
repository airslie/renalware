module Renalware
  module Feeds
    module HL7Segments
      # The MRG segment provides receiving applications with information necessary to initiate
      # the merging of patient data as well as groups of records. It is intended that this segment
      # be used throughout the Standard to allow the merging of registration, accounting, and
      # clinical records within specific applications.
      # E.g.
      #   MRG|123456^^^ICHT
      class MRG < SimpleDelegator
        def mrn
          prior_hospital_identifiers
        end

        def prior_hospital_identifiers
          return [] unless defined?(prior_patient_identifier_list)
          return [] if prior_patient_identifier_list.blank?

          @prior_hospital_identifiers ||= prior_patient_identifier_list
            .split("~")
            .each_with_object({}) do |field, hash|
              parts = field.split("^")
              hospno = parts.first
              assigning_authority = parts[3]&.to_sym
              hash[assigning_authority] = hospno
            end
            .compact_blank
        end
      end
    end
  end
end
