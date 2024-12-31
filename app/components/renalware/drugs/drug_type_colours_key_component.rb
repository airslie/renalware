module Renalware
  module Drugs
    class DrugTypeColoursKeyComponent < ApplicationComponent
      def colours_array
        Drugs::Type.where.not(colour: nil).order(:weighting).pluck(:name, :colour)
      end
    end
  end
end
