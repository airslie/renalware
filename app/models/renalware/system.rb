# frozen_string_literal: true

require_dependency "renalware"

module Renalware
  module System
    def self.table_name_prefix
      "system_"
    end
  end
end
