module Renalware
  module Geography
    def self.table_name_prefix = "geography_"

    class Engine < Rails::Engine
      isolate_namespace Geography
    end
  end
end
