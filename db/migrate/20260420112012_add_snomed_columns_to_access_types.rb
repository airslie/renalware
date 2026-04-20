class AddSnomedColumnsToAccessTypes < ActiveRecord::Migration[8.1]
  def change
    within_renalware_schema do
      add_column :access_types, :snomed_procedure_code, :string, comment: "used for UKRDC Procedure ie the initial Construction"
      add_column :access_types, :snomed_procedure_description, :string
      add_column :access_types, :snomed_finding_code, :string, comment: "used for UKRDC Dialysis Session and Dialysis Prescription"
      add_column :access_types, :snomed_finding_description, :string
      add_column :access_types, :snomed_structure_code, :string
      add_column :access_types, :snomed_structure_description, :string

      Renalware::Accesses::Type.reset_column_information

      Renalware::Accesses::Type
        .where(rr02_code: "NLN")
        .update!(
          snomed_procedure_code: "449860009",
          snomed_procedure_description: "Insertion of nontunneled central venous catheter",
          snomed_finding_code: "440535009",
          snomed_finding_description: "Nontunneled central venous catheter in situ",
          snomed_structure_code: "449859004",
          snomed_structure_description: "Nontunneled central venous catheter"
        )

      Renalware::Accesses::Type
        .where(rr02_code: "TLN")
        .update!(
          snomed_procedure_code: "442309004",
          snomed_procedure_description: "Insertion of tunneled venous catheter",
          snomed_finding_code: "439012009",
          snomed_finding_description: "Tunneled central venous catheter in situ",
          snomed_structure_code: "445085009",
          snomed_structure_description: "Tunnelled central venous catheter"
        )

      Renalware::Accesses::Type
        .where(rr02_code: "AVF")
        .update!(
          snomed_procedure_code: "27929005",
          snomed_procedure_description: "Construction of arteriovenous fistula",
          snomed_finding_code: "439784005",
          snomed_finding_description: "Surgically constructed arteriovenous fistula",
          snomed_structure_code: nil,
          snomed_structure_description: nil
        )

      Renalware::Accesses::Type
        .where(rr02_code: "AVG")
        .update!(
          snomed_procedure_code: "46196009",
          snomed_procedure_description: "Surgical construction of arteriovenous shunt",
          snomed_finding_code: "699007002",
          snomed_finding_description: "Arteriovenous shunt in situ",
          snomed_structure_code: "258622003",
          snomed_structure_description: "Arteriovenous shunt - device"
        )

      Renalware::Accesses::Type
        .where(rr02_code: "VLP")
        .update!(
          snomed_procedure_code: nil,
          snomed_procedure_description: nil,
          snomed_finding_code: "366161000000100",
          snomed_finding_description: "Surgically created vein loop",
          snomed_structure_code: nil,
          snomed_structure_description: nil
        )

      Renalware::Accesses::Type
        .where(rr02_code: "PDC")
        .update!(
          snomed_procedure_code: "180272001",
          snomed_procedure_description: "Insertion of chronic ambulatory peritoneal dialysis catheter",
          snomed_finding_code: nil,
          snomed_finding_description: nil,
          snomed_structure_code: "360133002",
          snomed_structure_description: "Chronic ambulatory peritoneal dialysis catheter (physical object)"
        )

      Renalware::Accesses::Type
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
end
