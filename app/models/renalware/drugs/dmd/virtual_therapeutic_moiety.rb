module Renalware
  class Drugs::DMD::VirtualTherapeuticMoiety < ApplicationRecord
    has_many :vmps,
             class_name: "Renalware::Drugs::DMD::VirtualMedicalProduct",
             foreign_key: :virtual_therapeutic_moiety_code,
             primary_key: :code,
             dependent: :nullify

    has_many :forms, -> { distinct },
             class_name: "Renalware::Drugs::DMD::Form",
             through: :vmps,
             source: :form

    has_many :units_of_measure, -> { distinct },
             class_name: "Renalware::Drugs::DMD::UnitOfMeasure",
             through: :vmps,
             source: :unit_of_measure

    has_many :routes, -> { distinct },
             class_name: "Renalware::Drugs::DMD::Route",
             through: :vmps,
             source: :route

    class ExportSyncQuery
      def call
        Drugs::DMD::VirtualTherapeuticMoiety.all
      end
    end
  end
end
