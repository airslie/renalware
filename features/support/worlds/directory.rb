module World
  module Directory
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/directory/*.rb")].each { |f| require f }
