require_relative "../../../seeds_helper"

# rubocop:disable Style/WordArray
module Renalware
  Rails.benchmark "Adding Drug Types" do
    drug_types = [
      {
        name: "Antibiotics",
        code: "antibiotic",
        atc_codes: ["J01", "J02", "J03"]
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
        atc_codes: ["C02", "C03", "C04", "C07", "C08", "C09"]
      },
      {
        name: "Bone / Calcium / Phosphate",
        code: "bone/Ca/PO4",
        atc_codes: ["A11CC", "A11CB", "A12AA", "A12AX", "V03AE02", "V03AE03"]
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
        colour: "sky"
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
        atc_codes: ["N05", "N06"]
      }
    ]

    now = DateTime.now
    upserts = drug_types.map do |obj|
      obj[:colour] ||= nil
      obj[:created_at] = now
      obj[:updated_at] = now
      obj
    end

    Renalware::Drugs::Type.upsert_all(drug_types, unique_by: :code)
  end
end
# rubocop:enable Style/WordArray
