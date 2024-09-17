# frozen_string_literal: true

module Renalware
  module UKRDC
    module Outgoing
      describe Rendering::Address do
        include XmlSpecHelper

        it do
          address = build(
            :address,
            street_1: "S1",
            street_2: "S2",
            street_3: "S3",
            town: "T",
            postcode: "P",
            county: "C"
          )
          country = build(:country, alpha3: "ABC", name: "123")
          allow(address).to receive(:country).and_return(country)
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Address use="H">
              <Street>S1, S2, S3</Street>
              <Town>T</Town>
              <County>C</County>
              <Postcode>P</Postcode>
              <Country>
                <CodingStandard>ISO3166-1</CodingStandard>
                <Code>ABC</Code>
                <Description>123</Description>
              </Country>
            </Address>
          XML

          xml = Ox.dump(described_class.new(address: address).xml, indent: -1)

          expect(xml).to eq(expected_xml)
        end

        it "omits Country if country code is blank" do
          address = build(
            :address,
            street_1: "S1",
            street_2: "S2",
            street_3: "S3",
            town: "T",
            postcode: "P",
            county: nil
          )
          expected_xml = <<~XML.squish.gsub("> <", "><")
            <Address use="H">
              <Street>S1, S2, S3</Street>
              <Town>T</Town>
              <County/>
              <Postcode>P</Postcode>
            </Address>
          XML

          xml = Ox.dump(described_class.new(address: address).xml, indent: -1)

          expect(xml).to eq(expected_xml)
        end
      end
    end
  end
end
