module Renalware
  NullUser = Naught.build do |config|
    config.black_hole
    config.define_explicit_conversions
    config.predicates_return false
  end
end
