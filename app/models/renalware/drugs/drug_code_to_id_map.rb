module Renalware
  module Drugs
    class DrugCodeToIdMap
      delegate :[], to: :map

      private

      def map
        @map ||= Drug.where.not(code: ["", nil]).pluck(:code, :id).to_h
      end
    end
  end
end
