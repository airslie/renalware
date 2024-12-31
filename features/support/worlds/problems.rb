module World
  module Problems
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/problems/*.rb")].each { |f| require f }
