# frozen_string_literal: true

module Renalware
  module Hospitals
    def self.table_name_prefix = "hospital_"

    class Engine < Rails::Engine
      isolate_namespace Hospitals
    end
  end
end
