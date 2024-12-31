# require_relative "configuration"

module Renalware
  module Research
    def self.table_name_prefix = "research_"

    class Engine < Rails::Engine
      isolate_namespace Research
    end
  end
end
