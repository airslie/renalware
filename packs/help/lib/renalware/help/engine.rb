module Renalware
  module Help
    def self.table_name_prefix = "help_"

    class Engine < Rails::Engine
      isolate_namespace Help
    end
  end
end
