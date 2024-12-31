# Matches PDF::Reader::Page text
RSpec::Matchers.define :have_pdf_page_text do |expected|
  match do |actual|
    actual
      .text
      .gsub(/(\n)+/, " ")
      .gsub(/(\t)+/, " ")
      .gsub(/( )+/, " ") =~ Regexp.new(expected)
  end
  failure_message do |actual|
    "expected that #{actual} would have text #{expected}"
  end
end
