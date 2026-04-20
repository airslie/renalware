require_relative "../../seeds_helper"

module Renalware
  Rails.benchmark "Adding Access Types" do
    file_path = File.join(File.dirname(__FILE__), "access_types.csv")

    CSV.foreach(file_path, headers: true) do |row|
      if row["rr02_code"].present?
        rr02_code = row["rr02_code"]
        abbreviation = rr02_code
      end

      if row["rr41_code"].present?
        rr41_code = row["rr41_code"]
        abbreviation = "#{rr02_code} #{rr41_code}"
      end

      Accesses::Type.find_or_create_by!(name: row["name"]) do |type|
        type.rr02_code = rr02_code
        type.rr41_code = rr41_code
        type.abbreviation = abbreviation
      end
    end

    Accesses::Type
      .where(rr02_code: "NLN")
      .update!(
        snomed_procedure_code: "449860009",
        snomed_procedure_description: "Insertion of nontunneled central venous catheter",
        snomed_finding_code: "440535009",
        snomed_finding_description: "Nontunneled central venous catheter in situ",
        snomed_structure_code: "449859004",
        snomed_structure_description: "Nontunneled central venous catheter"
      )

    Accesses::Type
      .where(rr02_code: "TLN")
      .update!(
        snomed_procedure_code: "442309004",
        snomed_procedure_description: "Insertion of tunneled venous catheter",
        snomed_finding_code: "439012009",
        snomed_finding_description: "Tunneled central venous catheter in situ",
        snomed_structure_code: "445085009",
        snomed_structure_description: "Tunnelled central venous catheter"
      )

    Accesses::Type
      .where(rr02_code: "AVF")
      .update!(
        snomed_procedure_code: "27929005",
        snomed_procedure_description: "Construction of arteriovenous fistula",
        snomed_finding_code: "439784005",
        snomed_finding_description: "Surgically constructed arteriovenous fistula",
        snomed_structure_code: nil,
        snomed_structure_description: nil
      )

    Accesses::Type
      .where(rr02_code: "AVG")
      .update!(
        snomed_procedure_code: "46196009",
        snomed_procedure_description: "Surgical construction of arteriovenous shunt",
        snomed_finding_code: "699007002",
        snomed_finding_description: "Arteriovenous shunt in situ",
        snomed_structure_code: "258622003",
        snomed_structure_description: "Arteriovenous shunt - device"
      )

    Accesses::Type
      .where(rr02_code: "VLP")
      .update!(
        snomed_procedure_code: nil,
        snomed_procedure_description: nil,
        snomed_finding_code: "366161000000100",
        snomed_finding_description: "Surgically created vein loop",
        snomed_structure_code: nil,
        snomed_structure_description: nil
      )

    Accesses::Type
      .where(rr02_code: "PDC")
      .update!(
        snomed_procedure_code: "180272001",
        snomed_procedure_description: "Insertion of chronic ambulatory peritoneal dialysis catheter",
        snomed_finding_code: nil,
        snomed_finding_description: nil,
        snomed_structure_code: "360133002",
        snomed_structure_description: "Chronic ambulatory peritoneal dialysis catheter (physical object)"
      )

    Accesses::Type
      .where(rr02_code: "PDT")
      .update!(
        snomed_procedure_code: "180277007",
        snomed_procedure_description: "Insertion of temporary peritoneal dialysis catheter (procedure)",
        snomed_finding_code: "440926006",
        snomed_finding_description: "Temporary peritoneal dialysis catheter in situ (finding)",
        snomed_structure_code: nil,
        snomed_structure_description: nil
      )
  end
end
