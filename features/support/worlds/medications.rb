module World
  module Medications
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/medications/*.rb")].each { |f| require f }
