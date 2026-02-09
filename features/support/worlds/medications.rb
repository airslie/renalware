module World
  module Medications
  end
end

Rails.root.glob("features/support/worlds/medications/*.rb").each { |f| require f }
