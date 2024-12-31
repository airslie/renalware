module World
  module Authoring
    def snippets_user(user)
      Renalware::Authoring.cast_user(user)
    end
  end
end

Dir[Renalware::Engine.root.join("features/support/worlds/snippets/*.rb")].each { |f| require f }
