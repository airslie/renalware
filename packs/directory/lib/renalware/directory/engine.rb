# frozen_string_literal: true

module Renalware
  module Directory
    def self.table_name_prefix = "directory_"

    class Engine < Rails::Engine
      isolate_namespace Directory
    end
  end
end
