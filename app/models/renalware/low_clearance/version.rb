# frozen_string_literal: true

require_dependency "renalware/low_clearance"

module Renalware
  module LowClearance
    class Version < PaperTrail::Version
      self.table_name = :low_clearance_versions
    end
  end
end
