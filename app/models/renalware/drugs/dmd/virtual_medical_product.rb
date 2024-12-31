module Renalware
  class Drugs::DMD::VirtualMedicalProduct < ApplicationRecord
    belongs_to :vtm,
               class_name: "Renalware::Drugs::DMD::VirtualTherapeuticMoiety",
               foreign_key: :virtual_therapeutic_moiety_code,
               primary_key: :code

    belongs_to :route,
               class_name: "Renalware::Drugs::DMD::Route",
               foreign_key: :route_code,
               primary_key: :code

    belongs_to :form,
               class_name: "Renalware::Drugs::DMD::Form",
               foreign_key: :form_code,
               primary_key: :code

    belongs_to :unit_of_measure,
               class_name: "Renalware::Drugs::UnitOfMeasure",
               foreign_key: :active_ingredient_strength_numerator_uom_code,
               primary_key: :code
  end
end
