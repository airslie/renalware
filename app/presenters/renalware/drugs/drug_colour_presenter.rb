module Renalware
  module Drugs
    class DrugColourPresenter
      # If a drug has many drug types, and each has a colour, we choose the
      # colour from the drug type with the greatest #weighting
      def css_class(drug)
        eligible_colors = drug.drug_types.sort_by(&:weighting).reverse.filter_map(&:colour)
        if eligible_colors.any?
          "bg-#{eligible_colors.first}-100 hover:bg-#{eligible_colors.first}-200"
        else
          drug.code.blank? ? "bg-green-50 hover:bg-green-100" : ""
        end
      end
    end
  end
end
