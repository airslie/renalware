module Renalware
  module Feeds
    module HL7Segments
      # PatientVisit1 segment
      class PV1 < SimpleDelegator
        class Clinic
          def initialize(field)
            @fields = field.split("^")
          end

          def code          = fields.first
          def name          = fields[1]
          def description   = fields[2]

          private

          attr_reader :fields
        end

        class Consultant
          def initialize(field)
            @fields = field.split("^")
          end

          def code        = fields.first
          def name        = [title, given_name, family_name].compact_blank.join(" ")
          def family_name = fields[1]
          def given_name  = fields[2]
          def title       = fields[5]
          def type        = fields[12]

          private

          attr_reader :fields
        end

        def clinic            = Clinic.new(assigned_location)
        def referring_doctor  = Consultant.new(super)
        def attending_doctor  = Consultant.new(super)
        def consulting_doctor = Consultant.new(super)
      end
    end
  end
end
