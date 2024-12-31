module Renalware
  module Drugs
    module DMDMigration
      class FormMatcher
        MAPPINGS = {
          "Effervescent Tablet": "Effervescent tablet",
          Tablet: "Tablet",
          Solution: "Solution for injection",
          Powder: "Powder",
          Capsule: "Capsule",
          Suspension: "Suspension for injection",
          Gel: "Gel",
          Cream: "Cream",
          Syrup: "Oral solution",
          Sponge: "Cutaneous sponge",
          Granules: "Granules",
          Suppository: "Suppository",
          # Elixir: "", # we won't be finding a match for it
          "Eye Drop": "Eye drops",
          "Nose Drops": "Nasal drops",
          "Ear Drop": "Ear drops",
          Patch: "Cutaneous patch",
          Lotion: "Liquid",
          Inhaler: "Inhalation solution"
        }.freeze

        def call
          forms_by_name = Drugs::Form.all.index_by(&:name)

          DMDMatch.find_each do |dmd_match|
            matched_key = MAPPINGS.keys.find do |pattern_match|
              dmd_match.drug_name.downcase.include? pattern_match.downcase.to_s
            end

            next if matched_key.nil?

            matched_name = MAPPINGS[matched_key]
            raise matched_name if matched_name.nil?

            matched_form = forms_by_name[matched_name]

            dmd_match.update_column(:form_name, matched_form.name)
          end
        end
      end
    end
  end
end
