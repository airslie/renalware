module Renalware
  class Medications::RoutesIndexedByCodeMap
    delegate :[], to: :map

    private

    def map
      @map ||= Medications::MedicationRoute.where.not(code: ["", nil]).index_by(&:code)
    end
  end
end
