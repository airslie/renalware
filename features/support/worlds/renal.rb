module World
  module Renal
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/renal/*.rb")].each { |f| require f }
