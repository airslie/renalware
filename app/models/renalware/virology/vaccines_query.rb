# frozen_string_literal: true

module Renalware
  module Virology
    # If the vaccination type has any values in its atc_codes array, use those to
    # filter drugs with a type of 'vaccine'. If no atc_codes, return all vaccine drugs.
    class VaccinesQuery
      pattr_initialize [:vaccination_type!]

      def call
        vaccination_type.atc_codes.any? ? vaccines_filtered_by_atc_code : all_vaccines
      end

      private

      def all_vaccines = Renalware::Drugs::PrescribableDrug.for(:vaccine).order(:compound_name)

      def vaccines_filtered_by_atc_code
        sql = <<~SQL.squish
          select distinct on(drug_prescribable_drugs.compound_name) drug_prescribable_drugs.* from drug_prescribable_drugs
          inner join drugs on drugs.id = drug_prescribable_drugs.drug_id
          inner join drug_types_drugs dtd on dtd.drug_id = drugs.id
          inner join drug_types dt on dt.id = dtd.drug_type_id
          inner join drug_dmd_virtual_medical_products ddvmp on ddvmp.virtual_therapeutic_moiety_code = drugs.code
          inner join virology_vaccination_types vvt on ddvmp.atc_code ~~ ANY(vvt.atc_codes)
          where dt.code = 'vaccine' and drugs.inactive = 'false' and vvt.id = ?
          order by drug_prescribable_drugs.compound_name
        SQL
        sanitized_sql = Vaccination.sanitize_sql([sql, vaccination_type.id])
        Drugs::PrescribableDrug.find_by_sql(sanitized_sql)
      end
    end
  end
end
