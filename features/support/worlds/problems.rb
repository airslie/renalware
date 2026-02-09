module World
  module Problems
  end
end

Rails.root.glob("features/support/worlds/problems/*.rb").each { |f| require f }
