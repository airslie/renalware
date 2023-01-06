# frozen_string_literal: true

module Renalware
  module Feeds
    module HL7Segments
      # PatientVisit1 segment
      class PV1 < SimpleDelegator
        class Clinic
          def initialize(field)
            @fields = field.split("^")
          end

          def code
            fields.first
          end

          def name
            fields[1]
          end

          def description
            fields[2]
          end

          private

          attr_reader :fields
        end

        class Consultant
          def initialize(field)
            @fields = field.split("^")
          end

          def code
            fields.first
          end

          def name
            [title, given_name, family_name].reject(&:blank?).join(" ")
          end

          def family_name
            fields[1]
          end

          def given_name
            fields[2]
          end

          def title
            fields[5]
          end

          def type
            fields[12]
          end

          private

          attr_reader :fields
        end

        def clinic
          Clinic.new(assigned_location)
        end

        def referring_doctor
          Consultant.new(super)
        end

        def consulting_doctor
          Consultant.new(super)
        end
      end
    end
  end
end
