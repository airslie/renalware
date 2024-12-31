RSpec::Matchers.define :match_document do |expected|
  match do |actual|
    actual.as_json == expected.as_json
  end
end
