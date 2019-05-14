# frozen_string_literal: true

module Renalware
  module DrugsHelper
    def drug_select_options
      options_for_select(
        Drugs::Type
          .all
          .reject { |dt| dt.name == "Peritonitis" }
          .map { |dt| [dt.name, dt.name.downcase] }
      )
    end

    def drug_types_colour_tag(drug_types)
      drug_names = drug_types.map(&:name)
      return "esa" if drug_names.include?("ESA")
      return "immunosuppressant" if drug_names.include?("Immunosuppressant")

      "other"
    end

    def drug_types_tag(drug_type)
      if drug_type.map(&:name).include?("ESA")
        "ESA"
      elsif drug_type.map(&:name).include?("Immunosuppressant")
        "Immunosuppressant"
      else
        "Standard"
      end
    end
  end
end
