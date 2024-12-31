module Renalware
  module Drugs
    module DMDMigration
      class PopulateAtcCodesForDrugTypes
        DRUG_TYPES = [
          {
            name: "Antibiotics",
            code: "antibiotic",
            atc_codes: %w(J01 J02 J03)
          },
          {
            name: "Controlled",
            code: "controlled",
            atc_codes: ["N02A"]
          },
          {
            name: "Cardiac",
            code: "cardiac",
            atc_codes: ["C"]
          },
          {
            name: "Hypertension",
            code: "hypertension",
            atc_codes: %w(C02 C03 C04 C07 C08 C09)
          },
          {
            name: "Bone / Calcium / Phosphate",
            code: "bone/Ca/PO4",
            atc_codes: %w(A11CC A11CB A12AA A12AX V03AE02 V03AE03)
          },
          {
            name: "Laxative",
            code: "laxative",
            atc_codes: ["A06"]
          },
          {
            name: "Diabetes",
            code: "diabetes",
            atc_codes: ["A10"]
          },
          {
            name: "ESA",
            code: "esa",
            colour: "yellow",
            atc_codes: ["B03XA"]
          },
          {
            name: "Immunosuppressant",
            code: "immunosuppressant",
            atc_codes: ["L04A"],
            colour: "blue"
          },
          {
            name: "Vaccine",
            code: "vaccine",
            atc_codes: ["J07"]
          },
          {
            name: "Antivirl",
            code: "Antivirl",
            atc_codes: ["J05"]
          },
          {
            name: "Iron",
            code: "iron",
            atc_codes: ["B03A"]
          },
          {
            name: "Anticoag Antiplatelet",
            code: "Anticoag Antiplatelet",
            atc_codes: ["B01"]
          },
          {
            name: "Psychiatric Medication",
            code: "Psychiatric Medication",
            atc_codes: %w(N05 N06)
          }
        ].freeze

        def call
          DRUG_TYPES.each_with_index do |drug_type, index|
            type = Drugs::Type.where(code: drug_type[:code]).first_or_initialize
            type.name ||= drug_type[:name]
            type.position ||= index
            type.colour ||= drug_type[:colour]
            type.atc_codes = drug_type[:atc_codes]
            type.save!
          end
        end
      end
    end
  end
end
