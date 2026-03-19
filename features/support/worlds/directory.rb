module World
  module Directory
  end
end

Rails.root.glob("features/support/worlds/directory/*.rb").each { |f| require f }
