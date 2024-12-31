module Renalware
  module Drugs::DMD
    module Repositories
      class VirtualMedicalProductRepository
        attr_reader :client

        VALUES = %w(
          ROUTECD
          FORMCD
          UNIT_DOSE_UOMCD
          BASIS_STRNTCD
          UDFS_UOMCD
          STRNT_NMRTR_UOMCD
          STRNT_NMRTR_VAL
          parent
          inactive
        ).freeze

        Entry = Struct.new(
          :name,
          :code,
          :virtual_therapeutic_moiety_code,
          :form_code,
          :route_code,
          :basis_of_strength,
          :strength_numerator_value,
          :active_ingredient_strength_numerator_uom_code,
          :unit_dose_uom_code,
          :unit_dose_form_size_uom_code,
          :inactive,
          keyword_init: true
        )

        def initialize(client: OntologyClient)
          @client = client.call
        end

        def call(count: 2, offset: 0) # rubocop:disable Metrics/AbcSize
          response = client.get(
            "production1/fhir/ValueSet/$expand", {
              url: "https://dmd.nhs.uk/ValueSet/VMP",
              property: VALUES,
              count:,
              offset:
            }
          )

          raise(OntologyClient::RequestFailed.new(response: response)) unless response.success?

          return [] if response.body["expansion"]["total"] == 0
          return [] if response.body.dig("expansion", "contains").blank?

          response.body["expansion"]["contains"].filter_map do |row|
            next if row["extension"].blank?

            Entry.new(
              name: row["display"],
              code: row["code"],
              virtual_therapeutic_moiety_code:
                dig(row["extension"], "parent", excluded_values: ["VMP"]),
              form_code: dig(row["extension"], "FORMCD"),
              route_code: dig(row["extension"], "ROUTECD"),
              basis_of_strength: dig(row["extension"], "BASIS_STRNTCD"),
              strength_numerator_value: dig(row["extension"], "STRNT_NMRTR_VAL"),
              active_ingredient_strength_numerator_uom_code:
                dig(row["extension"], "STRNT_NMRTR_UOMCD"),
              unit_dose_uom_code: dig(row["extension"], "UNIT_DOSE_UOMCD"),
              unit_dose_form_size_uom_code: dig(row["extension"], "UDFS_UOMCD"),
              inactive: dig(row["extension"], "inactive")
            )
          end
        end

        private

        def dig(*, **)
          ParseHelper.dig_property_out(*, **)
        end

        # rubocop:disable Layout/LineLength

        # Example response
        # [
        #  {"extension"=>
        #   [{"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>[{"url"=>"code", "valueCode"=>"FORMCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"385194003"}}]},
        #     {"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>[{"url"=>"code", "valueCode"=>"ROUTECD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"37161004"}}]},
        #     {"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>[{"url"=>"code", "valueCode"=>"UNIT_DOSE_UOMCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"430293001"}}]},
        #     {"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>
        #       [{"url"=>"code", "valueCode"=>"VPI"},
        #       {"url"=>"subproperty", "extension"=>[{"url"=>"code", "valueCode"=>"BASIS_STRNTCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk/BASIS_OF_STRNTH", "code"=>"1"}}]},
        #       {"url"=>"subproperty", "extension"=>[{"url"=>"code", "valueCode"=>"STRNT_NMRTR_VAL"}, {"url"=>"value", "valueDecimal"=>125.0}]},
        #       {"url"=>"subproperty", "extension"=>[{"url"=>"code", "valueCode"=>"STRNT_NMRTR_UOMCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"258684004"}}]}]}],
        #   "system"=>"https://dmd.nhs.uk",
        #   "code"=>"322278003",
        #   "display"=>"Paracetamol 125mg suppositories"},
        #
        # {"extension"=>
        #   [{"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>[{"url"=>"code", "valueCode"=>"FORMCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"385194003"}}]},
        #     {"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>[{"url"=>"code", "valueCode"=>"ROUTECD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"37161004"}}]},
        #     {"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>[{"url"=>"code", "valueCode"=>"UNIT_DOSE_UOMCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"430293001"}}]},
        #     {"url"=>"http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
        #     "extension"=>
        #       [{"url"=>"code", "valueCode"=>"VPI"},
        #       {"url"=>"subproperty", "extension"=>[{"url"=>"code", "valueCode"=>"BASIS_STRNTCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk/BASIS_OF_STRNTH", "code"=>"1"}}]},
        #       {"url"=>"subproperty", "extension"=>[{"url"=>"code", "valueCode"=>"STRNT_NMRTR_VAL"}, {"url"=>"value", "valueDecimal"=>500.0}]},
        #       {"url"=>"subproperty", "extension"=>[{"url"=>"code", "valueCode"=>"STRNT_NMRTR_UOMCD"}, {"url"=>"value", "valueCoding"=>{"system"=>"https://dmd.nhs.uk", "code"=>"258684004"}}]}]}],
        #   "system"=>"https://dmd.nhs.uk",
        #   "code"=>"322250004",
        #   "display"=>"Paracetamol 500mg suppositories"}
        # ]

        # rubocop:enable Layout/LineLength
      end
    end
  end
end
