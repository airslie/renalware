module World
  module Renal
  end
end

Rails.root.glob("features/support/worlds/renal/*.rb").each { |f| require f }
