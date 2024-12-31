module Renalware
  module PD
    class InfectionOrganism < ApplicationRecord
      belongs_to :organism_code
      belongs_to :infectable, polymorphic: true

      validates :organism_code, uniqueness: {
        scope: [:infectable_id, :infectable_type]
      }, presence: true

      def to_s
        organism_code.name
      end
    end
  end
end
