module Renalware
  module HD
    module Sessions
      class ProtocolSessionsQuery
        def initialize(patient:, limit: 3)
          @patient = patient
          @limit = limit
        end

        def call(*)
          Session
            .includes(:hospital_unit, :signed_off_by)
            .extending(Scopes)
            .for_patient(patient)
            .not_dna
            .limit(limit)
            .ordered
        end

        private

        attr_reader :patient, :limit

        module Scopes
          def for_patient(patient)
            where(patient: patient)
          end

          def not_dna
            where.not(type: Session::DNA.sti_name)
          end
        end
      end
    end
  end
end
