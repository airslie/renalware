# Load the packaged feature engines under /packs so their routes and initializers are available.
module Renalware
  module PackEngines
    def self.load!
      packs_root = File.expand_path("../../packs", __dir__)
      Dir[File.join(packs_root, "*/lib/**/engine.rb")].each { |f| require f }
    end
  end
end
