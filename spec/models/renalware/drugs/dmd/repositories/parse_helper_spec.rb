module Renalware
  module Drugs::DMD
    describe Repositories::ParseHelper do
      describe ".dig_property_out" do
        let(:extension_contains) do
          [{ "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
             "extension" => [{ "url" => "code", "valueCode" => "FORMCD" },
                             { "url" => "value",
                               "valueCoding" => { "system" => "https://dmd.nhs.uk",
                                                  "code" => "385194003" } }] },
           { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
             "extension" => [{ "url" => "code", "valueCode" => "ROUTECD" },
                             { "url" => "value",
                               "valueCoding" => { "system" => "https://dmd.nhs.uk",
                                                  "code" => "37161004" } }] },
           { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
             "extension" => [{ "url" => "code", "valueCode" => "UNIT_DOSE_UOMCD" },
                             { "url" => "value",
                               "valueCoding" => { "system" => "https://dmd.nhs.uk",
                                                  "code" => "430293001" } }] },
           { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
             "extension" => [{ "url" => "code", "valueCode" => "inactive" },
                             { "url" => "value", "valueBoolean" => false }] },

           { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
             "extension" => [{ "url" => "code", "valueCode" => "parent" },
                             { "url" => "value", "valueCode" => "VMP" }] },

           { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
             "extension" => [{ "url" => "code", "valueCode" => "parent" },
                             { "url" => "value", "valueCode" => "90332006" }] },

           { "url" => "http://hl7.org/fhir/5.0/StructureDefinition/extension-ValueSet.expansion.contains.property",
             "extension" =>
              [{ "url" => "code", "valueCode" => "VPI" },
               { "url" => "subproperty",
                 "extension" => [{ "url" => "code", "valueCode" => "BASIS_STRNTCD" },
                                 { "url" => "value",
                                   "valueCoding" => {
                                     "system" => "https://dmd.nhs.uk/BASIS_OF_STRNTH", "code" => "1"
                                   } }] },
               { "url" => "subproperty",
                 "extension" => [{ "url" => "code", "valueCode" => "STRNT_NMRTR_VAL" },
                                 { "url" => "value", "valueDecimal" => 125.0 }] },
               { "url" => "subproperty",
                 "extension" => [{ "url" => "code", "valueCode" => "STRNT_NMRTR_UOMCD" },
                                 { "url" => "value",
                                   "valueCoding" => { "system" => "https://dmd.nhs.uk",
                                                      "code" => "258684004" } }] }] }]
        end

        it "takes data out of properties" do
          expect(dig(extension_contains, "FORMCD")).to eq "385194003"
          expect(dig(extension_contains, "ROUTECD")).to eq "37161004"
          expect(dig(extension_contains, "UNIT_DOSE_UOMCD")).to eq "430293001"
          expect(dig(extension_contains, "BASIS_STRNTCD")).to eq "1"
          expect(dig(extension_contains, "STRNT_NMRTR_VAL")).to eq 125.0
          expect(dig(extension_contains, "STRNT_NMRTR_UOMCD")).to eq "258684004"
          expect(dig(extension_contains, "parent", excluded_values: ["VMP"])).to eq "90332006"
          expect(dig(extension_contains, "inactive")).to be false
        end

        def dig(*, **)
          described_class.dig_property_out(*, **)
        end
      end
    end
  end
end
