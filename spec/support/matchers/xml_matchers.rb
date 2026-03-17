# spec/support/xml_matchers.rb
require "nokogiri"

def pretty_xml(xml)
  doc = Nokogiri::XML(xml) { |c| c.noblanks } # rubocop:disable Style/SymbolProc
  Nokogiri::XML(doc.canonicalize).to_xml(indent: 2)
end

RSpec::Matchers.define :match_xml do |expected|
  match do |actual|
    @expected_pretty = pretty_xml(expected)
    @actual_pretty   = pretty_xml(actual)

    values_match?(@expected_pretty, @actual_pretty)
  end

  diffable

  failure_message do
    colour = RSpec.configuration.color
    "expected XML to match.\n\nDIFF:\n" \
      "#{RSpec::Support::Differ.new(color: colour).diff(@expected_pretty, @actual_pretty)}"
  end
end
